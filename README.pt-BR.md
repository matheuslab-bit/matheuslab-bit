# Olá, sou Matheus Silva

**Profissional de Infraestrutura de TI e Telecomunicações | Em formação para Google Cloud Engineer**

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

Atuo com infraestrutura de TI e telecomunicações, incluindo suporte técnico e análise de falhas SIP/VoIP. Também possuo experiência prática com Active Directory, VMware e Hyper-V. Atualmente, desenvolvo competências em Google Cloud por meio de laboratórios reproduzíveis, práticas de segurança, Terraform e testes documentados.

Meu objetivo é conquistar uma oportunidade **remota em engenharia ou operações de nuvem**. Este GitHub é um portfólio de aprendizado, não uma declaração de experiência profissional em nuvem de produção.

## Laboratórios Google Cloud em destaque

| Laboratório | O que demonstra | Status |
| --- | --- | --- |
| [01 — Redes VPC](projects/01-vpc-network/README.pt-BR.md) | VPC e sub-rede regional em São Paulo com Terraform, estados separados e validação pelo GitHub Actions | **Terraform e CI validados**; este laboratório não documenta evidências de implantação |
| [02 — Compute Engine seguro](projects/02-secure-compute-engine/README.pt-BR.md) | VM Debian 12 `e2-micro` privada em Iowa, SSH apenas por IAP, OS Login, Shielded VM, firewall restritivo e disco padrão de 10 GB | **Implantado; SSH via IAP/OS Login testado** (18 de novembro de 2026) |
| [Infraestrutura GCP segura — projeto inicial](projects/gcp-secure-infrastructure/README.md) | Referência inicial de Terraform para VM privada, redes, IAM e monitoramento | **Somente projeto; não implantado independentemente** |

O Lab 02 reutiliza a VPC existente sem mover ou substituir a sub-rede de São Paulo. A localização em Iowa foi escolhida para possível elegibilidade ao Free Tier do Google Cloud. **Elegibilidade não garante custo zero.**

[Ver índice dos projetos](projects/README.pt-BR.md) | [Acompanhar plano de estudos](ROADMAP.md)

## Foco técnico

- **Nuvem:** Google Cloud, Compute Engine, VPC, IAM, IAP, OS Login, Cloud Monitoring
- **Infraestrutura como código:** Terraform, Git, GitHub Actions
- **Sistemas e redes:** Linux, Windows, TCP/IP, DNS, firewalls e diagnóstico técnico
- **Experiência profissional:** operações SIP/VoIP, análise de incidentes e suporte de infraestrutura
- **Próximos passos:** Cloud Run, contêineres, observabilidade, automação e certificação Google Cloud Associate Cloud Engineer

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
