# Google Cloud Portfolio Projects

This folder contains practical Google Cloud learning projects. Each project's status must reflect the work actually completed.

## 1. Secure GCP Infrastructure

**Status: Terraform configuration prepared; not deployed to a live GCP project yet.**

Build a small cloud environment with a private VPC, restricted IAP-based SSH access, a Shielded Debian VM, least-privilege service account permissions, and Cloud Monitoring.

- [Project documentation and architecture](./gcp-secure-infrastructure/README.md)
- [Terraform configuration](./gcp-secure-infrastructure/)
- [Terraform learning notes and deployment instructions](./gcp-secure-infrastructure/README.md)

The initial Terraform configuration has been published. It still needs formatting/validation and a reviewed deployment in a personal Google Cloud project before it can be described as tested or deployed.

## 2. Cloud Application on GCP

**Status: Planned**

Goal: deploy a small application and its supporting services.

Planned components:
- Cloud Run
- Cloud SQL
- Artifact Registry
- Secret Manager
- Logging and monitoring

## 3. GCP Infrastructure Automation

**Status: Planned**

Goal: provision and update cloud infrastructure through version-controlled code.

Planned components:
- Terraform configuration
- Reusable variables and outputs
- IAM and network resources
- Validation and deployment workflow
- Documentation of cost and security considerations

## Project quality checklist

Before marking a project complete:
- [ ] The implementation has been tested.
- [ ] The README explains the problem and architecture.
- [ ] Setup and cleanup instructions are documented.
- [ ] An architecture diagram is included where useful.
- [ ] No credentials, tokens, or secrets are committed.
- [ ] Cost implications and resource cleanup are explained.
- [ ] Screenshots or other evidence show the real implementation.

These are portfolio learning projects unless explicitly stated otherwise. Do not present planned work as completed professional experience.
