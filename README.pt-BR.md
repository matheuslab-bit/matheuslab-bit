# Olá, sou Matheus Silva

**Profissional de Infraestrutura de TI e Telecomunicações | Em formação para Google Cloud Engineer**

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

Atuo com infraestrutura de TI e telecomunicações, incluindo suporte técnico e análise de falhas SIP/VoIP. Também possuo experiência prática com Active Directory, VMware e Hyper-V. Atualmente, desenvolvo competências em Google Cloud por meio de laboratórios reproduzíveis, práticas de segurança, Terraform e testes documentados.

Meu objetivo é conquistar uma oportunidade **remota em engenharia ou operações de nuvem**. Este GitHub é um portfólio de aprendizado, não uma declaração de experiência profissional em nuvem de produção.

## Laboratórios Google Cloud em destaque

| Laboratório | O que demonstra | Status |
| --- | --- | --- |
| [01 — Redes VPC](projects/01-vpc-network/README.pt-BR.md) | VPC personalizada (`portfolio-vpc`) e sub-rede regional (`10.10.0.0/24`) em São Paulo (`southamerica-east1`); state remoto no GCS com state locking e CI no GitHub Actions | **Implantado em São Paulo; state migrado para o GCS** (20 de novembro de 2026) |
| [02 — Compute Engine seguro](projects/02-secure-compute-engine/README.pt-BR.md) | VM Debian 12 `e2-micro` privada em Iowa (`us-central1-a`), SSH apenas por IAP, OS Login, Shielded VM, firewall `900`/`901`, disco padrão de 10 GB e state remoto no GCS | **Implantado em Iowa; SSH via IAP/OS Login testado e state migrado para o GCS** |
| [03 — Terraform Remote State (GCS)](projects/03-terraform-backend/README.pt-BR.md) | Bucket Cloud Storage endurecido em Iowa (`us-central1`) com versionamento de objetos, Soft Delete de 7 dias, ciclo de vida de 90 dias, acesso uniforme, prevenção de acesso público e proteções contra exclusão | **Implantado em Iowa; armazenando os states dos Labs 01 e 02** (20 de novembro de 2026) |

O Lab 02 compartilha a VPC global `portfolio-vpc` criada no Lab 01, gerenciando sua própria sub-rede em Iowa (`10.20.0.0/24`). Tanto o Lab 01 quanto o Lab 02 armazenam seus estados Terraform em prefixos isolados dentro do bucket GCS endurecido provisionado pelo Lab 03, com bloqueio nativo de estado (`.tflock`). A região de Iowa (`us-central1`) foi escolhida para possível elegibilidade ao Free Tier do Google Cloud. **Elegibilidade não garante custo zero.**

*Referência histórica:* o protótipo monolítico inicial permanece preservado em [`projects/archive/gcp-secure-infrastructure/`](projects/archive/gcp-secure-infrastructure/README.md) e foi sucedido pelos laboratórios modulares acima.

[Ver índice dos projetos](projects/README.pt-BR.md) | [Acompanhar plano de estudos](ROADMAP.md)

## Foco técnico

- **Demonstrado nos laboratórios publicados:** redes VPC no Google Cloud, Compute Engine (VM privada Debian 12, Shielded VM), Cloud Storage (backend de Terraform Remote State, versionamento de objetos, Soft Delete de 7 dias, regras de ciclo de vida, state locking), isolamento de contas de serviço IAM, encaminhamento TCP via IAP, OS Login, ordenação de regras de firewall VPC, Terraform, Git e validação de CI com GitHub Actions
- **Base em sistemas e redes:** Linux, Windows Server/Active Directory, VMware, Hyper-V, TCP/IP, DNS, firewalls e diagnóstico de infraestrutura SIP/VoIP
- **Estudo ativo e próximos laboratórios:** Workload Identity Federation (CI/CD sem chaves), Cloud Monitoring e Cloud Logging, Cloud NAT, Cloud Run, Artifact Registry, Cloud SQL, Secret Manager, contêineres e certificação Google Cloud Associate Cloud Engineer (ACE)

## Como documento meu trabalho

1. Defino objetivo, arquitetura e escopo de cada laboratório.
2. Versiono a configuração e verifico com validações automatizadas.
3. Registro escolhas de segurança, permissões e cuidados com custos.
4. Distingo claramente o que foi **planejado**, **validado** e **implantado/testado**.
5. Não publico credenciais, estados do Terraform ou informações sensíveis de infraestrutura.

## Contato

- **E-mail:** [matheus.silva.gcp@gmail.com](mailto:matheus.silva.gcp@gmail.com)
- **GitHub:** [github.com/matheuslab-bit](https://github.com/matheuslab-bit)

---

*Portfólio em desenvolvimento. Os exercícios de infraestrutura são para aprendizado, não hospedagem de produção.*
