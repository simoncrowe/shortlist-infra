# shortlist-infra

Infrastructure-as-code for **Shortlist** — a system that uses LLMs to automatically assess recruitment candidate profiles against job listings.

## Architecture

- **GKE cluster** with a general-purpose node pool and a **Spot GPU node pool** for LLM inference
- **Multi-cloud**: GCP for compute/storage, AWS SES for transactional email (SPF, DKIM, DMARC)
- **Cross-cloud auth** via OIDC workload identity federation (GKE &rarr; AWS IAM)
- **GCS model cache** to avoid redundant transformer model downloads

## Components

| Helm Release | Purpose |
|---|---|
| `shortlist-runner` | Core profile assessment orchestration |
| `shortlist-llm-assessor` | LLM inference on GPU nodes |
| `shortlist-rm-ingester` | Recruitment data ingestion (optional) |
| `shortlist-rm-email-notifier` | Email notifications to recruiters (optional) |

## Tech Stack

Terraform &middot; GKE &middot; Helm &middot; AWS SES &middot; GCS &middot; OIDC Federation
