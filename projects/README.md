# Google Cloud Portfolio Projects

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

This folder contains reproducible Google Cloud learning labs. Each project's status distinguishes between **code validation**, **cloud deployment**, and **tested access**.

## Published labs

| Project | Scope | Verified progress |
| --- | --- | --- |
| [01 — VPC Networking](01-vpc-network/README.md) | Terraform configuration for a custom VPC and regional subnet in São Paulo | Terraform formatting/validation and GitHub Actions checks completed. This lab does not contain independent cloud deployment evidence. |
| [02 — Secure Compute Engine](02-secure-compute-engine/README.md) | Private Debian 12 `e2-micro` VM in Iowa; dedicated subnet, IAP-based SSH, OS Login, Shielded VM and restrictive firewall | Deployment and SSH through IAP/OS Login tested on November 18, 2026. Terraform CI passed for the change in [PR #4](https://github.com/matheuslab-bit/matheuslab-bit/pull/4). |

**Architecture note:** Lab 02 references the existing VPC from Lab 01, but manages its own Iowa subnet and its own Terraform state. The São Paulo subnet remains in place. Neither lab should overwrite the other's state.

**Cost note:** The Iowa `e2-micro` and 10 GB `pd-standard` disk may qualify for Google Cloud's Free Tier within its usage limits. Billing and other services can still incur charges.

## Earlier design (separate from Labs 01 and 02)

- [GCP Secure Infrastructure](gcp-secure-infrastructure/README.md) — an initial Terraform architecture reference including private compute, security and monitoring. **Not independently deployed or verified.** It must not be confused with the completed Lab 02.

## Planned projects

- **Cloud Application on GCP:** Cloud Run, Artifact Registry, Cloud SQL, Secret Manager and observability.
- **Infrastructure Automation:** reusable Terraform and CI/CD workflows.

Planned work is intentionally excluded from the completed-labs table.

## Project quality checklist

- [x] Keep source code in version control and document the architecture.
- [x] Use Terraform validation and automated checks where applicable.
- [x] Record security trade-offs and cost considerations.
- [ ] Add sanitized evidence (commands/output or screenshots) for each deployed lab.
- [ ] Publish a tested cloud application with reproducible instructions.

Never commit secrets, Terraform state, unredacted credentials or private access tokens. This is a **learning portfolio**, not a production service catalog.
