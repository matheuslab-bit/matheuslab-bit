# Hi, I'm Matheus Silva

**IT Infrastructure & Telecommunications Professional | Aspiring Google Cloud Engineer**

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

I work with IT and telecommunications infrastructure, including SIP/VoIP troubleshooting and technical support. My background also includes hands-on experience with Active Directory, VMware, and Hyper-V. I am now building practical Google Cloud engineering skills through reproducible labs, security-first design, Terraform, and documented testing.

My goal is to move into a **remote cloud engineering or cloud operations role**. This GitHub profile is a learning portfolio, not a claim of production cloud experience.

## Featured Google Cloud labs

| Lab | What it demonstrates | Status |
| --- | --- | --- |
| [01 — VPC Networking](projects/01-vpc-network/README.md) | Terraform-managed VPC and regional subnet design in São Paulo; separate state and GitHub Actions validation | **Terraform and CI validated**; deployment evidence is not documented in this lab |
| [02 — Secure Compute Engine](projects/02-secure-compute-engine/README.md) | Private Debian 12 `e2-micro` VM in Iowa, IAP-only SSH, OS Login, Shielded VM, restricted firewall and 10 GB standard disk | **Deployed; IAP/OS Login SSH tested** (November 18, 2026) |

The Lab 02 infrastructure reuses the existing VPC without moving or replacing the São Paulo subnet. Its Iowa location was selected for potential Google Cloud Free Tier eligibility. **Eligibility is not a guarantee of zero charges.**

*Historical reference:* the earlier monolithic prototype is preserved in [`projects/archive/gcp-secure-infrastructure/`](projects/archive/gcp-secure-infrastructure/README.md) and was superseded by the modular labs above.

[Browse the project index](projects/README.md) | [Follow the learning roadmap](ROADMAP.md)

## Technical focus

- **Demonstrated in published labs:** Google Cloud VPC design, Compute Engine (private Debian 12 VM, Shielded VM), IAM service account isolation, IAP TCP forwarding, OS Login, stateful VPC firewall ordering, Terraform, Git, and GitHub Actions CI validation
- **Systems and networking foundation:** Linux, Windows Server/Active Directory, VMware, Hyper-V, TCP/IP, DNS, firewalls, and SIP/VoIP infrastructure troubleshooting
- **Active study & upcoming labs:** Terraform Remote State (Cloud Storage), Workload Identity Federation (keyless CI/CD), Cloud Monitoring and Cloud Logging, Cloud NAT, Cloud Run, Artifact Registry, Cloud SQL, Secret Manager, containers, and the Google Cloud Associate Cloud Engineer (ACE) certification

## How I document my work

1. Define the goal, architecture and scope of each lab.
2. Version configuration and validate it with automated checks.
3. Record security decisions, permissions and cost considerations.
4. Separate **planned**, **validated** and **deployed/tested** work.
5. Do not publish credentials, Terraform state or sensitive infrastructure details.

## Contact

- **Email:** [matheus.silva.gcp@gmail.com](mailto:matheus.silva.gcp@gmail.com)
- **GitHub:** [github.com/matheuslab-bit](https://github.com/matheuslab-bit)

---

*Portfolio in progress. Infrastructure exercises are for learning, not production hosting.*
