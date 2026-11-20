# Plano de Estudos em Engenharia Google Cloud

[English](ROADMAP.md) | [Português (Brasil)](ROADMAP.pt-BR.md)

Este plano acompanha a trilha de aprendizado rumo a uma vaga de nível inicial em engenharia Google Cloud. É um plano, não uma declaração de experiência concluída. Cada seção é atualizada conforme laboratórios e projetos são finalizados.

## Fase 1 — Fundamentos de nuvem, Linux e redes

**Tópicos**
- Conceitos de computação em nuvem: IaaS, PaaS, SaaS, regiões, zonas e modelo de responsabilidade compartilhada
- Linha de comando Linux, usuários, permissões, processos, serviços, SSH e diagnóstico básico
- Redes: TCP/IP, DNS, HTTP/HTTPS, sub-redes, roteamento, NAT e firewalls
- Git, GitHub e scripts básicos em Python ou shell

**Evidências a publicar**
- Um laboratório documentado de administração Linux
- Anotações de redes e exercícios de troubleshooting

## Fase 2 — Serviços principais do Google Cloud

**Tópicos**
- Organizações, pastas, projetos e faturamento
- Papéis IAM, contas de serviço e menor privilégio
- Compute Engine e Cloud Storage
- Redes VPC, sub-redes, rotas e regras de firewall
- Cloud DNS, Cloud SQL e Cloud Run
- Balanceamento de carga e conceitos básicos de disponibilidade

**Evidências a publicar**
- Um pequeno ambiente GCP documentado com diagrama de arquitetura
- Uma aplicação de exemplo implantada

## Fase 3 — Operações e segurança em nuvem

**Tópicos**
- Cloud Logging e Cloud Monitoring
- Alertas, logs de auditoria e investigação de incidentes
- Desenho de IAM e segurança de contas de serviço
- Fundamentos de Secret Manager e Cloud KMS
- Segurança de rede e proteção de cargas de trabalho
- Fundamentos de backup, recuperação e confiabilidade

**Evidências a publicar**
- Uma carga de trabalho monitorada no GCP
- Uma revisão de segurança explicando riscos e mitigações

## Fase 4 — Automação e DevOps

**Tópicos**
- Terraform e Infraestrutura como Código
- Fundamentos de Docker e contêineres
- Fundamentos de Kubernetes e conceitos do Google Kubernetes Engine
- Fundamentos de CI/CD
- Cloud Build, Artifact Registry e GitHub Actions
- Automação com Bash e Python

**Evidências a publicar**
- Infraestrutura reproduzível com Terraform
- Um fluxo de implantação documentado

## Fase 5 — Certificação e preparação para vagas

**Metas**
- Preparar-se para a certificação Google Cloud Associate Cloud Engineer
- Concluir laboratórios práticos e revisar pontos fracos
- Publicar pelo menos três projetos de portfólio testados e documentados
- Preparar um currículo técnico e praticar entrevistas
- Candidatar-se a vagas de nível inicial em suporte de nuvem, operações de nuvem, infraestrutura e engenharia de nuvem júnior

## Rotina de estudos

Base sugerida: 10 horas por semana, divididas entre:
1. Estudo estruturado e documentação
2. Laboratórios práticos guiados
3. Reconstrução dos exercícios de forma independente
4. Documentação do portfólio e prática de inglês técnico

## Registro de progresso

Os marcos só são marcados quando há evidência publicada (README do laboratório, pull request ou execução de CI).

- [ ] Fundamentos de nuvem e redes
- [ ] Laboratório de fundamentos de Linux
- [ ] Primeiro projeto GCP e proteções de faturamento (alertas de orçamento ainda a documentar)
- [x] Laboratório de Compute Engine e VPC — [Lab 01](projects/01-vpc-network/README.pt-BR.md) e [Lab 02](projects/02-secure-compute-engine/README.pt-BR.md)
- [ ] Laboratório de IAM e segurança (parcialmente coberto pelo Lab 02: conta de serviço dedicada, IAP, OS Login)
- [ ] Implantação de aplicação no Cloud Run
- [ ] Laboratório de monitoramento e logs
- [x] Projeto de infraestrutura com Terraform — Labs 01 a 03 com backend de state remoto no GCS
- [x] Três projetos de portfólio documentados — [índice dos projetos](projects/README.pt-BR.md)
- [ ] Preparação para o exame Associate Cloud Engineer

### Registros datados

- **18/11/2026:** Lab 01 (VPC) e Lab 02 (VM privada com IAP e OS Login) integrados com validação de CI; Lab 02 implantado em Iowa e acesso SSH testado.
- **20/11/2026:** Lab 03 (state remoto no GCS) implantado; states dos Labs 01 e 02 migrados para o GCS com `No changes` verificado.
- **20/11/2026:** CI consolidado em um único workflow Terraform com scan de segurança Checkov; riscos aceitos documentados no próprio código.

### Próximos passos

1. Workload Identity Federation para autenticação sem chaves no GitHub Actions (permite `terraform plan` no CI).
2. Laboratório de monitoramento e logs (Cloud Monitoring, Cloud Logging, VPC Flow Logs, alertas de orçamento).
3. Aplicação no Cloud Run com Artifact Registry e Secret Manager.
