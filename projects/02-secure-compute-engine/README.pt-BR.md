# Laboratório 02 — Secure Compute Engine em Iowa

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

**Resultado informado e testado em 18/11/2026:** VM `lab02-secure-vm` implantada em Iowa, sem IP público, com SSH via IAP e OS Login funcionando. O PR [#4](https://github.com/matheuslab-bit/matheuslab-bit/pull/4) foi integrado após aprovação das verificações de CI. Este registro documenta o teste realizado; não representa certificação de ambiente de produção.

VM Linux privada no projeto `driven-surface-513117-k0`, na região `us-central1`, elegível ao Free Tier. A mudança para Iowa foi autorizada em 18/11/2026 para reduzir custos, preservando a infraestrutura existente de São Paulo.

## Arquitetura e propriedade dos recursos

| Componente | Configuração | Gestão |
|---|---|---|
| VPC existente | `portfolio-vpc`, consultada por data source | Lab 01, preservada |
| Subnet de São Paulo | `portfolio-subnet`, `southamerica-east1`, `10.10.0.0/24` | Lab 01, preservada |
| Nova subnet de Iowa | `lab02-iowa-subnet`, `us-central1`, `10.20.0.0/24`, IPv4 | Lab 02 |
| VM | `lab02-secure-vm`, `us-central1-a`, `e2-micro`, STANDARD | Lab 02 |
| Disco de boot | 10 GB `pd-standard`, Debian 12, auto_delete | Parte da VM |
| Conta dedicada | `lab02-secure-vm`, sem chaves ou papéis de aplicação | Lab 02 |
| Firewall SSH | Allow IAP 900; deny outras origens 901 | Lab 02 |

A VPC é global: adicionar uma subnet em Iowa não move a subnet de São Paulo. O Lab 02 gerencia sua própria subnet para não acessar nem modificar o state do Lab 01. Não copiar states entre laboratórios. A faixa `10.20.0.0/24` deve permanecer livre de sobreposição; foi conferida na VPC antes da implantação.

O plano inicial esperado contém **5 adições, 0 alterações e 0 exclusões**: subnet, conta de serviço, duas regras e VM (incluindo o disco). Uma VM já implantada em outra região exigiria uma revisão de migração; esta adaptação foi preparada quando o projeto não tinha VMs nem discos.

## Segurança e limites

- VM sem IP público e sem IPv6; nenhum bloco `access_config`.
- SSH TCP/22 permitido apenas de `35.235.240.0/20` (IAP), prioridade 900. Deny de `0.0.0.0/0`, prioridade 901. Ambas as regras têm como alvo somente a conta dedicada; não reutilizar essa conta em outras VMs.
- A VM depende explicitamente das duas regras. Revisar também políticas efetivas e regras de prioridade superior antes da implantação.
- OS Login ativo; chaves SSH do projeto bloqueadas; acesso serial desativado.
- Secure Boot, vTPM e integrity monitoring ativos. Isso não instala agente de observabilidade.
- Conta dedicada sem chaves e sem concessões IAM de aplicação. O scope `cloud-platform` não concede papéis IAM.
- Nenhum recurso IAM de binding ou habilitação de API é gerenciado aqui. Não ampliar permissões como contorno de erros.
- Sem NAT, proxy, startup script ou instalação de pacotes. Private Google Access explicitamente desabilitado somente na nova subnet. A subnet de São Paulo não é alterada.
- IAP fornece entrada administrativa, não saída para internet. Atualizações Debian e downloads exigem um caminho de saída aprovado separadamente. Comunicação interna continua sujeita a rotas e firewall; ausência de NAT não representa bloqueio de toda saída.
- A família Debian 12 pode resolver para uma imagem diferente em planos futuros. Não apresentar esta VM como atualizada ou pronta para produção sem estratégia de patches e validação operacional.

## Pré-requisitos

Faturamento ativo, capacidade de `e2-micro` e disco em Iowa, VPC existente e APIs Compute, IAM, IAP e OS Login habilitadas. Não habilitar outras APIs como parte desta adaptação.

A identidade que executa Terraform precisa de leitura da VPC/imagens, uso e gestão da nova subnet, criação da VM/disco, gestão das duas regras e da conta dedicada, além de `iam.serviceAccounts.actAs` na conta anexada. Não confundir administração da conta com actAs; não conceder Owner/Editor para resolver falhas. A revisão operacional deve verificar os acessos já existentes antes de considerar novas concessões.

Para SSH: acesso IAP, OS Login (ou OS Admin Login para sudo), descoberta da instância e Service Account User na conta anexada, conforme os requisitos do Google. Não adicionar bindings automaticamente. Se faltarem permissões, interromper e registrar o requisito exato.

## Validação e execução

Executar exclusivamente nesta pasta. Terraform compatível com `>= 1.9.8, < 2.0.0`; CI usa 1.9.8. Provider Google **7.46.2**, preservando o lockfile versionado.

```powershell
terraform fmt -check -recursive
terraform init -backend=false -lockfile=readonly -input=false
terraform validate
terraform plan -input=false -out=lab02-iowa.tfplan
```

O init é necessário somente se os providers ainda não estiverem preparados. `-lockfile=readonly` é opção de init, não de plan. Revisar o plano salvo antes do apply; não aplicar o plano antigo de São Paulo. Não executar outros projetos do repositório.

Após implantação, conferir o output `ssh_command` e executar SSH pelo IAP:

```powershell
gcloud compute ssh lab02-secure-vm --project=driven-surface-513117-k0 --zone=us-central1-a --tunnel-through-iap
```

Conferir ausência de IP externo, tipo/tamanho do disco, três opções Shielded, subnet correta e funcionamento do OS Login. Uma verificação com `terraform plan` deve retornar ausência de alterações.

## Custos

O Free Tier inclui o equivalente mensal de uma `e2-micro` não preemptiva nas regiões `us-central1`, `us-west1` ou `us-east1`, e 30 GB-mês de disco padrão nas regiões elegíveis, dentro dos limites da conta de faturamento. Esta configuração usa uma VM e 10 GB; não inclui IP público, NAT, snapshots, balanceador ou imagem premium.

A franquia é compartilhada: outros projetos e uso anterior no mês podem consumi-la. Inventário atual vazio não comprova ausência de consumo histórico. Estimativa de VM e disco: US$0 dentro da franquia; fora dela, consultar preços atuais de Iowa e considerar impostos e tráfego. O usuário definiu US$10/mês como teto aceitável para o Lab 02; isso não configura bloqueio automático de faturamento. Não prometer custo zero absoluto.

## Estado e manutenção

O state local pertence exclusivamente ao Lab 02. Não versionar `.terraform/`, state, planos, tfvars, credenciais, chaves ou logs. Manter uma única cópia operacional do state e não executar applies concorrentes.

Nenhuma limpeza ou destruição está autorizada neste fluxo. A VPC e a subnet de São Paulo devem permanecer. Qualquer remoção futura exige autorização separada e revisão dos recursos afetados; nunca executar destroy do Lab 01 para limpar o Lab 02.

## Histórico

O PR #3, integrado por `554bf71`, estabeleceu prioridades 900/901 e dependência explícita da VM nas regras. A adaptação para Iowa mantém esses controles e acrescenta uma subnet exclusiva do Lab 02. A preparação anterior foi validada com Terraform 1.17.2 e provider 7.46.2; cada nova revisão precisa de seus próprios checks.

## Referências

- [Free Tier e limites compartilhados](https://docs.cloud.google.com/free/docs/free-cloud-features?hl=pt-br)
- [Preços de VM](https://cloud.google.com/products/compute/pricing/general-purpose)
- [Preços de discos](https://cloud.google.com/compute/disks-image-pricing)
- [IAP TCP forwarding](https://docs.cloud.google.com/iap/docs/using-tcp-forwarding)
- [OS Login](https://docs.cloud.google.com/compute/docs/oslogin/set-up-oslogin)
- [Service accounts e actAs](https://docs.cloud.google.com/iam/docs/service-accounts-actas)
- [Prioridade de firewall](https://docs.cloud.google.com/firewall/docs/firewalls)
