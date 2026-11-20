# Google Cloud Engineering Roadmap

[English](ROADMAP.md) | [Português (Brasil)](ROADMAP.pt-BR.md)

This roadmap tracks the learning path toward an entry-level Google Cloud engineering role. It is a plan, not a claim of completed experience. Update each section as labs and projects are completed.

## Phase 1 — Cloud, Linux, and networking foundations

**Topics**
- Cloud computing concepts: IaaS, PaaS, SaaS, regions, zones, and shared responsibility
- Linux command line, users, permissions, processes, services, SSH, and basic troubleshooting
- Networking: TCP/IP, DNS, HTTP/HTTPS, subnetting, routing, NAT, and firewalls
- Git, GitHub, and basic Python or shell scripting

**Evidence to publish**
- A documented Linux administration lab
- Networking notes and troubleshooting exercises

## Phase 2 — Google Cloud core services

**Topics**
- Organizations, folders, projects, and billing
- IAM roles, service accounts, and least privilege
- Compute Engine and Cloud Storage
- VPC networks, subnets, routes, and firewall rules
- Cloud DNS, Cloud SQL, and Cloud Run
- Load balancing and basic availability concepts

**Evidence to publish**
- A small GCP environment documented with an architecture diagram
- A deployed sample application

## Phase 3 — Operations and cloud security

**Topics**
- Cloud Logging and Cloud Monitoring
- Alerting, audit logs, and incident investigation
- IAM design and service account security
- Secret Manager and Cloud KMS fundamentals
- Network security and workload protection
- Backup, recovery, and reliability fundamentals

**Evidence to publish**
- A monitored GCP workload
- A security review explaining risks and mitigations

## Phase 4 — Automation and DevOps

**Topics**
- Terraform and Infrastructure as Code
- Docker and container fundamentals
- Kubernetes fundamentals and Google Kubernetes Engine concepts
- CI/CD fundamentals
- Cloud Build, Artifact Registry, and GitHub Actions
- Bash and Python automation

**Evidence to publish**
- Reproducible infrastructure using Terraform
- A documented deployment workflow

## Phase 5 — Certification and job preparation

**Targets**
- Prepare for the Google Cloud Associate Cloud Engineer certification
- Complete practice labs and review weak areas
- Publish at least three tested, documented portfolio projects
- Prepare a technical CV and practice interviews
- Apply to entry-level cloud support, cloud operations, infrastructure, and junior cloud engineering roles

## Study routine

Suggested baseline: 10 hours per week, split across:
1. Structured learning and documentation
2. Guided hands-on labs
3. Rebuilding exercises independently
4. Portfolio documentation and English technical practice

## Progress log

Milestones are checked only when there is published evidence (lab README, pull request, or CI run).

- [ ] Cloud and networking foundations
- [ ] Linux fundamentals lab
- [ ] First GCP project and billing safeguards (budget alerts still to be documented)
- [x] Compute Engine and VPC lab — [Lab 01](projects/01-vpc-network/README.md) and [Lab 02](projects/02-secure-compute-engine/README.md)
- [ ] IAM and security lab (partially covered by Lab 02: dedicated service account, IAP, OS Login)
- [ ] Cloud Run application deployment
- [ ] Monitoring and logging lab
- [x] Terraform infrastructure project — Labs 01–03 with a GCS remote state backend
- [x] Three portfolio projects documented — [project index](projects/README.md)
- [ ] Associate Cloud Engineer exam preparation

### Dated entries

- **2026-11-18:** Lab 01 (VPC) and Lab 02 (private VM with IAP and OS Login) merged with CI validation; Lab 02 deployed in Iowa and SSH access tested.
- **2026-11-20:** Lab 03 (GCS remote state) deployed; Lab 01 and Lab 02 states migrated to GCS with `No changes` verified.
- **2026-11-20:** CI consolidated into a single Terraform workflow with a Checkov security scan; accepted risks documented inline.

### Next steps

1. Workload Identity Federation for keyless GitHub Actions authentication (enables `terraform plan` in CI).
2. Monitoring and logging lab (Cloud Monitoring, Cloud Logging, VPC Flow Logs, budget alerts).
3. Cloud Run application with Artifact Registry and Secret Manager.
