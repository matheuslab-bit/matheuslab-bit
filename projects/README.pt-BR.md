# Projetos do Portfólio Google Cloud

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

Esta pasta reúne laboratórios reproduzíveis de estudo em Google Cloud. O status de cada projeto distingue **validação de código**, **implantação na nuvem** e **acesso testado**.

## Laboratórios publicados

| Projeto | Escopo | Progresso verificado |
| --- | --- | --- |
| [01 — Redes VPC](01-vpc-network/README.pt-BR.md) | Configuração Terraform para VPC personalizada e sub-rede regional em São Paulo | Formatação/validação Terraform e verificações no GitHub Actions concluídas. Este laboratório não apresenta evidência independente de implantação na nuvem. |
| [02 — Compute Engine seguro](02-secure-compute-engine/README.pt-BR.md) | VM Debian 12 `e2-micro` privada em Iowa; sub-rede dedicada, SSH por IAP, OS Login, Shielded VM e firewall restritivo | Implantação e SSH por IAP/OS Login testados em 18 de novembro de 2026. CI do Terraform passou no [PR #4](https://github.com/matheuslab-bit/matheuslab-bit/pull/4). |

**Arquitetura:** O Lab 02 consulta a VPC existente do Lab 01, mas gerencia a própria sub-rede em Iowa e o próprio estado Terraform. A sub-rede de São Paulo permanece preservada. Os estados dos laboratórios não devem ser sobrescritos entre si.

**Custos:** A máquina `e2-micro` em Iowa e o disco `pd-standard` de 10 GB podem se enquadrar no Free Tier do Google Cloud dentro dos limites de uso. Faturamento e outros serviços ainda podem gerar cobranças.

## Projeto inicial (separado dos Labs 01 e 02)

- [GCP Secure Infrastructure](gcp-secure-infrastructure/README.md) — referência inicial de arquitetura Terraform para computação privada, segurança e monitoramento. **Não foi implantado nem verificado de forma independente.** Não confundir com o Lab 02 concluído.

## Próximos projetos planejados

- **Aplicação no Google Cloud:** Cloud Run, Artifact Registry, Cloud SQL, Secret Manager e observabilidade.
- **Automação de infraestrutura:** Terraform reutilizável e fluxos CI/CD.

Trabalhos ainda planejados não são apresentados como laboratórios concluídos.

## Lista de qualidade dos projetos

- [x] Versionar código e documentar a arquitetura.
- [x] Usar validação Terraform e testes automatizados quando aplicável.
- [x] Registrar decisões de segurança e cuidados com custos.
- [ ] Adicionar evidências sem dados sensíveis (comandos/saídas ou imagens) dos laboratórios implantados.
- [ ] Publicar uma aplicação na nuvem testada com instruções reproduzíveis.

Não publicar segredos, estados Terraform, credenciais ou tokens de acesso. Este é um **portfólio de estudos**, não um catálogo de serviços em produção.
