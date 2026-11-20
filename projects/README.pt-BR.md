# Projetos do Portfólio Google Cloud

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

Esta pasta reúne laboratórios reproduzíveis de estudo em Google Cloud. O status de cada projeto distingue **validação de código**, **implantação na nuvem** e **acesso testado**.

## Laboratórios publicados

| Projeto | Escopo | Progresso verificado |
| --- | --- | --- |
| [01 — Redes VPC](01-vpc-network/README.pt-BR.md) | VPC em modo personalizado (`portfolio-vpc`) e sub-rede regional (`10.10.0.0/24`) em São Paulo (`southamerica-east1`) | Implantado em São Paulo; CI do Terraform aprovado ([PR #1](https://github.com/matheuslab-bit/matheuslab-bit/pull/1)), estado migrado localmente para o GCS (`labs/01-vpc-network`) com `terraform init -migrate-state` em 20 de novembro de 2026 (`No changes` verificado) e `backend.tf` versionado no [PR #10](https://github.com/matheuslab-bit/matheuslab-bit/pull/10). |
| [02 — Compute Engine seguro](02-secure-compute-engine/README.pt-BR.md) | VM Debian 12 `e2-micro` privada em Iowa (`us-central1-a`); sub-rede dedicada (`10.20.0.0/24`), SSH por IAP, OS Login, Shielded VM e firewall `900`/`901` | Configuração para Iowa integrada no [PR #4](https://github.com/matheuslab-bit/matheuslab-bit/pull/4); após o merge, implantado em Iowa e SSH por IAP/OS Login validado em 18 de novembro de 2026. Estado migrado localmente para o GCS (`labs/02-secure-compute-engine`) com `terraform init -migrate-state` em 20 de novembro de 2026 (`No changes` verificado) e `backend.tf` versionado no [PR #10](https://github.com/matheuslab-bit/matheuslab-bit/pull/10). |
| [03 — Terraform Remote State (GCS)](03-terraform-backend/README.pt-BR.md) | Bucket Cloud Storage dedicado em Iowa (`us-central1`) com versionamento de objetos, Soft Delete de 7 dias, ciclo de vida de 90 dias, acesso uniforme, prevenção de acesso público e proteções contra exclusão | Implantado em Iowa em 20 de novembro de 2026 ([PR #9](https://github.com/matheuslab-bit/matheuslab-bit/pull/9)); armazena os objetos ativos de estado remoto do Terraform dos Labs 01 e 02 e utiliza objetos temporários `.tflock` durante operações com state locking. |

**Arquitetura e estado:** O Lab 02 consulta a VPC `portfolio-vpc` do Lab 01 via data source e gerencia sua própria sub-rede em Iowa. Tanto o Lab 01 quanto o Lab 02 utilizam o backend remoto GCS criado no Lab 03 com prefixos isolados (`labs/01-vpc-network` e `labs/02-secure-compute-engine`) e bloqueio nativo de estado (*state locking*). O Lab 03 mantém seu próprio estado de bootstrap local (com cópia de backup local fora do repositório) para evitar dependência circular de backend.

**Custos:** A máquina `e2-micro` em Iowa, o disco `pd-standard` de 10 GB e o bucket Standard Storage em `us-central1` (~24 KB de estados) estão dimensionados dentro das franquias mensais do Free Tier do Google Cloud. Cotas compartilhadas da conta de faturamento, tráfego de saída e outros serviços ainda podem gerar cobranças.

## Protótipo arquivado

- [GCP Secure Infrastructure (arquivado)](archive/gcp-secure-infrastructure/README.md) — protótipo monolítico inicial em Terraform cobrindo computação privada, segurança e monitoramento. Foi sucedido pelos projetos modulares **Lab 01**, **Lab 02** e **Lab 03** acima e permanece preservado em `projects/archive/` para reaproveitamento futuro de suas ideias de observabilidade.

## Próximos projetos planejados

- **Aplicação no Google Cloud:** Cloud Run, Artifact Registry, Cloud SQL, Secret Manager e observabilidade.
- **Automação de infraestrutura:** Workload Identity Federation (CI/CD sem chaves) e módulos Terraform reutilizáveis.

Trabalhos ainda planejados não são apresentados como laboratórios concluídos.

## Lista de qualidade dos projetos

- [x] Versionar código e documentar a arquitetura.
- [x] Usar validação Terraform e testes automatizados quando aplicável ([`terraform-ci.yml`](../.github/workflows/terraform-ci.yml)).
- [x] Analisar o Terraform com Checkov e documentar cada risco aceito no próprio código.
- [x] Gerenciar os estados dos laboratórios remotamente em bucket GCS versionado e com state locking.
- [x] Registrar decisões de segurança e cuidados com custos.
- [ ] Publicar uma aplicação na nuvem testada com instruções reproduzíveis.

Não publicar segredos, estados Terraform, credenciais ou tokens de acesso. Este é um **portfólio de estudos**, não um catálogo de serviços em produção.
