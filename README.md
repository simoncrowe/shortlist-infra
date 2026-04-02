# shortlist-infra

Infrastructure-as-code for **Shortlist** — a system that uses LLMs to automatically assess real-estate listings.

## Architecture

- **GKE cluster** with a general-purpose node pool and a **Spot GPU node pool** for LLM inference
- **Multi-cloud**: GCP for compute/storage, AWS SES for transactional email (SPF, DKIM, DMARC)
- **Cross-cloud auth** via OIDC workload identity federation (GKE &rarr; AWS IAM)
- **GCS model cache** to avoid redundant transformer model downloads

## Components

| Component | Purpose |
|---|---|
| [`shortlist-runner`](https://github.com/simoncrowe/shortlist-runner) | Core profile assessment orchestration |
| [`shortlist-llm-assessor`](https://github.com/simoncrowe/shortlist-llm-assessor) | LLM inference on GPU nodes |
| [`shortlist-rm-ingester`](https://github.com/simoncrowe/shortlist-rm-ingester) | Web scraping/data ingestion (optional) |
| [`shortlist-rm-email-notifier`](https://github.com/simoncrowe/shortlist-rm-email-notifier) | Email notifications to house hunter (optional) |

Helm releases for most of these components live [here](https://github.com/simoncrowe/helm/tree/main/charts).

## Tech Stack

Terraform &middot; GKE &middot; Helm &middot; AWS SES &middot; GCS &middot; OIDC Federation
