# Laboratório 01 — Rede VPC no Google Cloud

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

Configuração Terraform de uma VPC personalizada e uma sub-rede regional. Este laboratório é independente de `../gcp-secure-infrastructure/` e deve ser executado a partir desta pasta, com seu próprio estado.

## Arquitetura

- VPC `portfolio-vpc`, sem criação automática de sub-redes e com roteamento regional.
- Sub-rede `portfolio-subnet`, com CIDR `10.10.0.0/24`.
- Região padrão: São Paulo (`southamerica-east1`).
- Outputs com nome e identificador da VPC, nome, CIDR e região da sub-rede.

## Origem e status

Os cinco arquivos originais foram importados do commit local `3bbe522e141bf5fe9cb505a9a606f0b42b6fb98c` do projeto `GoogleCloudPortfolio`. O `.gitignore` da raiz original foi copiado para esta pasta. O histórico original permanece no repositório local de origem.

Esta integração não executa implantação no Google Cloud. A existência de estado no projeto de origem não foi usada como comprovação de recursos ativos. O workflow dedicado verifica formatação e validade da configuração; ele não executa `plan`, `apply` ou `destroy`.

## Verificação desta integração

A formatação (`terraform fmt -check -recursive`), a inicialização sem backend com lockfile somente para leitura e `terraform validate` passaram localmente com Terraform 1.17.2 e provedor Google 7.46.2. As duas execuções do GitHub Actions (`push` e `pull_request`) foram concluídas com sucesso com Terraform 1.9.8, validando `terraform fmt -check -recursive`, `terraform init -backend=false -lockfile=readonly` e `terraform validate`. Nenhum `plan`, `apply` ou `destroy` foi executado nesta integração.

## Pré-requisitos

- Terraform 1.9.8 (versão usada no workflow).
- Projeto Google Cloud com faturamento e Compute Engine API habilitados.
- Identidade autenticada com permissão para gerenciar redes no projeto.
- Google Cloud CLI para autenticação local, se necessário.

O provedor Google usa `~> 7.0`, com versão `7.46.2` registrada em `.terraform.lock.hcl`. O outro projeto mantém seu próprio provedor 6.x; não combine os arquivos ou estados dos dois laboratórios.

## Validação sem implantação

Execute nesta pasta:

```powershell
terraform fmt -check -recursive
terraform init -backend=false -lockfile=readonly
terraform validate
```

A inicialização baixa o provedor, mas não cria recursos na nuvem.

## Implantação manual opcional

Revise o projeto de destino e os nomes para evitar conflitos com recursos existentes. Nunca use `apply` para assumir o gerenciamento de uma rede já existente em outro estado.

```powershell
gcloud auth application-default login
terraform init -lockfile=readonly
terraform plan -var="project_id=SEU_PROJECT_ID"
```

Depois de revisar o plano, uma implantação manual pode ser feita com `terraform apply -var="project_id=SEU_PROJECT_ID"`, mantendo a confirmação interativa. Região, nomes e CIDR podem ser alterados por variáveis. Não salve credenciais em arquivos Terraform.

## Limpeza e custos

Caso você tenha criado recursos com este estado, revise o projeto e o estado corretos antes de executar `terraform destroy -var="project_id=SEU_PROJECT_ID"`. Confirme que a rede não atende outros recursos. Avalie os custos do projeto e de serviços associados antes de implantar.

Mantenha `.terraform/`, arquivos de estado, planos, credenciais e `*.tfvars` fora do Git. O lockfile deve permanecer versionado. Não copie o estado do laboratório de origem para esta pasta como parte da integração.
