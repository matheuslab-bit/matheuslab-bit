# Laboratório 02 — Secure Compute Engine

Código para uma futura VM Linux privada no projeto `driven-surface-513117-k0`. A implantação depende de autorização explícita, revisão de custos e configuração dos pré-requisitos. Esta entrega não cria recursos GCP nem altera IAM ou APIs.

## Arquitetura e isolamento

```mermaid
flowchart LR
  User[Administrador autorizado] -->|HTTPS + IAM| IAP[IAP TCP forwarding]
  IAP -->|35.235.240.0/20 TCP 22| FW[Firewall direcionado à service account]
  FW --> Login[OS Login]
  subgraph Existing[Lab 01: portfolio-vpc / portfolio-subnet]
    Login --> VM[Debian 12 / e2-micro / Shielded VM / IP privado]
  end
  VM --- SA[Service account lab02-secure-vm / sem papéis de aplicação]
```

| Componente | Configuração |
|---|---|
| Rede existente | `portfolio-vpc`, consultada por data source |
| Subnet existente | `portfolio-subnet`, `southamerica-east1`, `10.10.0.0/24`, consultada por data source |
| VM futura | `lab02-secure-vm`, `southamerica-east1-a`, `e2-micro` |
| Disco | 10 GB `pd-standard`, Debian 12, removido com a VM |
| Recursos gerenciados pelo Lab 02 | Uma VM com disco de boot, uma service account e duas regras de firewall |

A zona aceita apenas `southamerica-east1-a`, `b` ou `c`. Uma precondição confere o CIDR e a associação da subnet à VPC antes de criar a VM. A imagem usa a família Debian 12: a versão resolvida pode mudar entre planos; para produção, avaliar fixar uma imagem específica após testes.

Execute sempre nesta pasta. O Lab 02 tem configuração e lockfile próprios; um eventual state local pertence exclusivamente a ele. Não há `terraform_remote_state`, import, backend compartilhado nem recursos Terraform para criar/gerenciar VPC e subnet. Nunca copie o state do Lab 01 para cá. A dependência de rede continua existindo: remover a subnet/VPC do Lab 01 exige considerar a VM do Lab 02. Os demais projetos do repositório são independentes e não devem ser executados como parte deste laboratório.

## Controles de segurança e limites

- Sem `access_config` e com `IPV4_ONLY`: a VM não recebe IP público nem IPv6.
- SSH via IAP, com allow TCP/22 de `35.235.240.0/20` em prioridade 1000. Um deny TCP/22 de `0.0.0.0/0` em prioridade 1001 impede que regras VPC de prioridade inferior liberem outras origens. Ambas as regras têm como alvo somente a conta dedicada; não reutilize essa conta em outras VMs.
- Antes de implantar, revisar as políticas efetivas, inclusive regras hierárquicas e regras VPC de prioridade superior ou igual. Elas podem sobrepor ou bloquear este desenho. Nenhuma política existente foi inspecionada ou modificada nesta entrega.
- OS Login habilitado somente nos metadados desta VM; chaves SSH de projeto bloqueadas e acesso serial desabilitado. Não há chaves embutidas ou senha no Terraform.
- Secure Boot, vTPM e integrity monitoring habilitados. Isso não instala um agente de observabilidade nem configura alertas.
- Conta `lab02-secure-vm` sem chaves e sem concessões IAM de aplicação. O scope `cloud-platform` é o limite OAuth recomendado pelo Google; as permissões efetivas continuam limitadas pelo IAM. Revisar também concessões herdadas ou existentes antes de implantar. Não há necessidade de Editor, Owner ou papéis de logs/monitoramento para esta VM vazia.
- Sem NAT, proxy, startup script ou instalação de pacotes. O IAP permite entrada administrativa, mas não fornece saída para a internet. Atualizações de pacotes exigem um caminho de saída aprovado separadamente. Private Google Access depende da subnet existente e não é alterado aqui. A regra implícita de saída da VPC não é um controle de restrição de egress; esta configuração não promete isolamento de saída.

## Pré-requisitos para futura implantação

Um administrador deve revisar e preparar estes requisitos **somente após autorização do usuário**. Nenhum deles é automatizado pelo laboratório.

1. Projeto correto, faturamento ativo, quota/capacidade de VM e disco na região, e rede/subnet existentes confirmadas. A existência foi informada pelo usuário; `validate` não consulta a nuvem.
2. APIs necessárias disponíveis: `compute.googleapis.com`, `iam.googleapis.com`, `iap.googleapis.com` e `oslogin.googleapis.com`. `serviceusage.googleapis.com` é relevante para verificar/gerenciar APIs e quota; habilitação de serviços requer uma identidade administrativa separada. Não há `google_project_service` nesta configuração.
3. Identidade de provisionamento com leitura da rede/subnet e imagens, criação/gestão da VM e disco, uso da subnet, gestão das duas regras de firewall e criação/gestão da service account. Como referência de papéis predefinidos: `roles/compute.instanceAdmin.v1`, `roles/compute.networkUser` e `roles/compute.securityAdmin`, no menor escopo suportado. Esses papéis cobrem mais operações que o lab; prefira permissões customizadas revisadas. Para a SA, `roles/iam.serviceAccountAdmin` permite administrar seu ciclo de vida e política IAM, mas **não inclui** `iam.serviceAccounts.actAs`. Já `roles/iam.serviceAccountUser` inclui `actAs` para anexar a SA à VM, mas não permite administrar a SA. Não conceder esses papéis amplamente por conveniência, nem usar Owner/Editor. O Terraform não concede esses acessos; seguir o bootstrap abaixo.
4. Administrador humano com `roles/iap.tunnelResourceAccessor` restrito à VM (preferencialmente condicionado a `destination.port == 22`), `roles/compute.osLogin` para login normal ou `roles/compute.osAdminLogin` quando sudo for necessário. Se o papel OS Login for concedido na instância, fornecer também `compute.projects.get` no projeto para o uso por console/gcloud. O gcloud precisa descobrir a instância (`compute.instances.get` e `compute.instances.list`); avaliar um papel customizado de leitura. Como esta VM tem uma SA anexada, o OS Login também exige `roles/iam.serviceAccountUser` para o usuário SSH, exclusivamente nessa SA, conforme a documentação do Google. Essa necessidade é distinta do provisionamento e não exige `roles/iam.serviceAccountAdmin`, gestão de firewall ou criação de VMs para o usuário SSH. Se já houver acesso efetivo suficiente, não duplicar a concessão. Para usuários externos à organização, pode ser necessário `roles/compute.osLoginExternalUser` na organização. Separar o usuário que concede acesso do usuário que abre o túnel.
5. Terraform 1.9.8 (CI) ou compatível com `>= 1.9.8, < 2.0.0`; provider Google fixado em `7.46.2`, com checksums próprios de Windows/Linux no lockfile. CLI gcloud e autenticação local via ADC para uma etapa futura; preferir credenciais temporárias, sem exportar chaves JSON.

## Bootstrap mínimo de actAs — somente em futura implantação autorizada

O principal de provisionamento é a identidade que executará Terraform; não é automaticamente o usuário SSH nem a SA da VM. Registrar seu membro IAM exato (`user:EMAIL` ou `serviceAccount:EMAIL`). Um administrador IAM separado deve ter `iam.serviceAccounts.getIamPolicy` e `iam.serviceAccounts.setIamPolicy` na SA dedicada; não conceder gestão de IAM ao usuário SSH para resolver este bootstrap.

1. Após autorização específica e com os pré-requisitos preparados, executar nesta pasta um plano excepcional com `-target=google_service_account.vm`, revisar que ele cria **somente** a SA `lab02-secure-vm` em `driven-surface-513117-k0` e aplicar apenas esse plano aprovado. Isso mantém a SA no state exclusivo do Lab 02, sem criá-la manualmente fora do Terraform. Se ela já estiver nesse state e existir, pular esta criação. O uso de target limita-se a este bootstrap, não à operação normal.
2. Com a SA existente, o administrador IAM separado adiciona `roles/iam.serviceAccountUser` **na política da própria SA** `lab02-secure-vm@driven-surface-513117-k0.iam.gserviceaccount.com`, tendo como membro somente o principal de provisionamento identificado. Usar uma adição de binding que preserve os demais membros; não conceder o papel no projeto, pasta ou organização. Referência para essa etapa futura (substituir o membro; não executado nesta entrega):

   ```powershell
   gcloud iam service-accounts add-iam-policy-binding lab02-secure-vm@driven-surface-513117-k0.iam.gserviceaccount.com --project=driven-surface-513117-k0 --member="user:EMAIL_DO_PROVISIONADOR" --role=roles/iam.serviceAccountUser
   ```

3. Conferir o membro e o escopo do binding, aguardar a propagação IAM e confirmar o acesso efetivo `iam.serviceAccounts.actAs` do provisionador nessa SA. Só então gerar um **novo plano completo, sem target**, revisar VM/disco e as duas regras de firewall restantes e solicitar autorização específica antes de aplicar. Não prosseguir com erro de permissão nem ampliar o escopo do papel como contorno.

A criação inicial exige `iam.serviceAccounts.create` no projeto; a gestão posterior deve limitar-se à SA dedicada, com permissões customizadas revisadas quando possível. O papel `serviceAccountAdmin` é referência de administração, não uma concessão obrigatória ao provisionador ou ao usuário SSH. Nenhum binding, chave ou papel de aplicação para a SA é adicionado ao Terraform.

## Validação sem acesso ao GCP

Na raiz do repositório:

```powershell
cd projects/02-secure-compute-engine
terraform fmt -check -recursive
terraform init -backend=false -lockfile=readonly -input=false
terraform validate
```

Esses comandos verificam sintaxe, formatação e schema do provider. O init baixa o provider do registro, sem backend remoto. Não verificam disponibilidade, IAM, APIs, custo ou políticas efetivas e não leem os data sources no GCP.

O workflow `.github/workflows/02-secure-compute-engine-check.yml` executa os mesmos três checks com Terraform 1.9.8, apenas quando arquivos deste lab/workflow mudam, ou por acionamento manual. Tem apenas `contents: read`, sem credenciais GCP ou autenticação cloud. Não executa plan/apply/destroy. O lockfile deve ficar versionado; sua atualização é uma alteração deliberada a revisar.

Validação local desta entrega: os três comandos acima passaram com Terraform 1.17.2 e provider Google 7.46.2. Os resultados de CI com Terraform 1.9.8 ficam disponíveis nos checks do PR. Não foi executado plan/apply/destroy, autenticação GCP ou consulta dos recursos existentes.

## Operação futura — exige nova autorização

Após revisão e autorização dos pré-requisitos, custos e identidade, a próxima etapa será autenticação ADC e revisão de um plano **somente desta pasta**. Comandos de referência, não executados nesta entrega:

```powershell
gcloud auth application-default login
terraform init -lockfile=readonly
terraform plan
```

Concluir primeiro o bootstrap mínimo de actAs descrito acima. O plano completo lê a VPC/subnet existentes e deve propor somente a VM/disco e as duas regras restantes; a conta dedicada já deve estar no state do Lab 02. Se indicar criação/alteração de VPC, subnet ou qualquer recurso inesperado, interrompa. Revisar o plano antes de pedir autorização específica para apply. Não há aplicação ou destruição automática.

Somente depois de implantação autorizada e IAM preparado, conectar usando:

```powershell
gcloud compute ssh lab02-secure-vm --project=driven-surface-513117-k0 --zone=southamerica-east1-a --tunnel-through-iap
```

Se a zona mudar, ajustar o comando; o output `ssh_command` fornece a zona selecionada. Evidências futuras: ausência de IP externo, três opções Shielded ativas, SSH via IAP funcionando com OS Login e impossibilidade de SSH de outra origem. Essas verificações operacionais ainda estão pendentes e dependem de implantação autorizada.

## Custos e limpeza futura

**Criar esta VM gera cobrança potencial. Não trate `e2-micro` em São Paulo como gratuita.** Calcular antes de implantar: horas de `e2-micro` em `southamerica-east1`, 10 GB de disco persistente, transferência de dados e eventuais serviços adicionados. Consultar preços atuais e configurar orçamento/alertas com aprovação separada; alertas não são limite automático de gastos. NAT não faz parte deste lab e teria custo adicional se incluído depois.

Parar a VM reduz custos de CPU/memória, mas o disco continua cobrado. Planejar uma janela curta de teste. Após autorização específica de limpeza, conferir diretório, projeto e state exclusivos do Lab 02 e revisar um plano de destruição antes de executar qualquer remoção. O disco de boot acompanha a remoção da VM (`auto_delete = true`); dados necessários devem ser preservados antes. A rede/subnet do Lab 01 não pertencem ao state deste lab e devem permanecer. Nunca executar destroy do Lab 01 para limpar este lab.

Não versionar `.terraform/`, state, planos, tfvars, credenciais, chaves ou arquivos locais. JSON legítimo pode ser versionado; para credenciais JSON, usar os nomes específicos ignorados (por exemplo, `credentials.json`, `service-account*.json`, `*-key.json` ou `secrets.json`). O nome não detecta segredos: revisar sempre o conteúdo dos arquivos preparados para commit.

## Referências

- [IAP TCP forwarding: faixa de origem, IAM e conexão](https://docs.cloud.google.com/iap/docs/using-tcp-forwarding)
- [Configuração do OS Login e papéis necessários](https://docs.cloud.google.com/compute/docs/oslogin/set-up-oslogin)
- [Papéis IAM: Service Account User e Service Account Admin](https://docs.cloud.google.com/iam/docs/roles-permissions/iam)
- [Permissão actAs para anexar service accounts](https://docs.cloud.google.com/iam/docs/service-accounts-actas)
- [Provider Google 7.46.2: Compute Instance](https://registry.terraform.io/providers/hashicorp/google/7.46.2/docs/resources/compute_instance)
- [Boas práticas para service accounts de VM e scopes](https://docs.cloud.google.com/compute/docs/access/service-accounts)
- [Preços de Compute Engine](https://cloud.google.com/compute/all-pricing)
- [Calculadora de custos](https://cloud.google.com/products/calculator)
