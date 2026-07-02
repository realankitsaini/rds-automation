#  Ephemeral Database Sandbox Engine (Aurora PostgreSQL)

This project contains an advanced Infrastructure as Code (IaC) blueprint using **Terraform** and **GitHub Actions** to automate the creation of on-demand database sandboxes. 

Tailored for development and automated testing workflows, this system spins up a completely isolated, lightweight **Amazon Aurora PostgreSQL** cluster cloned directly from a specific backup snapshot whenever a developer interacts with a Pull Request (PR)—and completely destroys it once the work is done.

---

##  Architecture & Safeguards

* **No Automated Failures:** Replaces unpredictable account-wide API searches with explicit manual inputs at the prompt or via pipeline configuration triggers, stopping "query returned no results" errors.
* **Engine & Version Fluidity:** Configured specifically for the `aurora-postgresql` ecosystem. By omitting hardcoded engine version strings, AWS natively auto-detects version data (e.g., `17.7`) directly from your source snapshot headers.
* **Network Enclosure:** Provisions a dedicated VPC per sandbox run using the dynamic branch or PR number. The security group isolates database traffic, opening up port `5432` only to components running inside the sandbox cluster.
* **Zero-Waste Lifecycles:** Enforces `skip_final_snapshot = true` to optimize teardown latency. Resources drop immediately when a branch closes, eliminating cloud sprawl and idle resource costs.

---

## 📁 Repository Schema

```text
rds-automation/
├── .github/workflows/
│   └── pr-lifecycle.yml         # GitHub Actions orchestration workflow
├── main.tf                      # Network boundary definitions (VPC, Subnets, SG)
├── aurora.tf                    # DB Cluster & Instance restoring configurations
├── variables.tf                 # Variable definitions for manual prompts
└── outputs.tf                   # Exposed connection string endpoints
