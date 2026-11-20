# Google Cloud Portfolio Projects

[English](README.md) | [Português (Brasil)](README.pt-BR.md)

This folder contains reproducible Google Cloud learning labs. Each project's status distinguishes between **code validation**, **cloud deployment**, and **tested access**.

## Published labs

| Project | Scope | Verified progress |
| --- | --- | --- |
| [01 — VPC Networking](01-vpc-network/README.md) | Custom-mode VPC (`portfolio-vpc`) and regional subnet (`10.10.0.0/24`) in São Paulo (`southamerica-east1`) | Deployed in São Paulo; Terraform CI passed ([PR #1](https://github.com/matheuslab-bit/matheuslab-bit/pull/1)), state migrated locally to GCS (`labs/01-vpc-network`) via `terraform init -migrate-state` on November 20, 2026 (`No changes` verified), and `backend.tf` versioned in [PR #10](https://github.com/matheuslab-bit/matheuslab-bit/pull/10). |
| [02 — Secure Compute Engine](02-secure-compute-engine/README.md) | Private Debian 12 `e2-micro` VM in Iowa (`us-central1-a`); dedicated subnet (`10.20.0.0/24`), IAP-only SSH, OS Login, Shielded VM, and priority `900`/`901` firewall | Iowa configuration merged in [PR #4](https://github.com/matheuslab-bit/matheuslab-bit/pull/4); following the merge, deployed in Iowa and SSH via IAP/OS Login tested on November 18, 2026. State migrated locally to GCS (`labs/02-secure-compute-engine`) via `terraform init -migrate-state` on November 20, 2026 (`No changes` verified), and `backend.tf` versioned in [PR #10](https://github.com/matheuslab-bit/matheuslab-bit/pull/10). |
| [03 — Terraform Remote State (GCS)](03-terraform-backend/README.md) | Dedicated Cloud Storage bucket in Iowa (`us-central1`) with object versioning, 7-day Soft Delete, 90-day noncurrent lifecycle rule, uniform bucket-level access, public access prevention, and deletion guardrails | Deployed in Iowa on November 20, 2026 ([PR #9](https://github.com/matheuslab-bit/matheuslab-bit/pull/9)); stores the active remote Terraform state objects for Labs 01 and 02 and supports temporary `.tflock` objects during state-locking operations. |

**Architecture & state note:** Lab 02 queries the existing `portfolio-vpc` from Lab 01 via data source while managing its own Iowa subnet. Both Lab 01 and Lab 02 use the remote GCS backend created in Lab 03 with isolated prefixes (`labs/01-vpc-network` and `labs/02-secure-compute-engine`) and native state locking. Lab 03 retains its own bootstrap state locally (with a separate local backup outside the repository) to avoid circular backend dependencies.

**Cost note:** The Iowa `e2-micro` VM, 10 GB `pd-standard` boot disk, and `us-central1` Standard Storage bucket (~24 KB of state data) are sized within Google Cloud's monthly Free Tier allowances. Shared billing quotas, network egress, and additional services can still incur charges.

## Archived prototype

- [GCP Secure Infrastructure (archived)](archive/gcp-secure-infrastructure/README.md) — initial monolithic Terraform design covering private compute, security and monitoring. Superseded by the modular **Lab 01**, **Lab 02**, and **Lab 03** projects above; preserved in `projects/archive/` so its observability ideas can be reused in future labs.

## Planned projects

- **Cloud Application on GCP:** Cloud Run, Artifact Registry, Cloud SQL, Secret Manager and observability.
- **Infrastructure Automation:** Workload Identity Federation (keyless CI/CD) and reusable Terraform modules.

Planned work is intentionally excluded from the completed-labs table.

## Project quality checklist

- [x] Keep source code in version control and document the architecture.
- [x] Use Terraform validation and automated checks where applicable.
- [x] Manage downstream lab states remotely in a versioned, locked GCS bucket.
- [x] Record security trade-offs and cost considerations.
- [ ] Publish a tested cloud application with reproducible instructions.

Never commit secrets, Terraform state, unredacted credentials or private access tokens. This is a **learning portfolio**, not a production service catalog.
