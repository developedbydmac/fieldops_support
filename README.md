# FieldOps Support AI — Tier-1 Assistant

**Tagline:** Guided fixes for cameras, Wi-Fi, ports, and logins—with clean escalations.

## 0) Quick Facts
- **Cloud:** Azure — **Why:** strong enterprise identity, APIM, Monitor/Log Analytics, Key Vault.
- **Phase Today:** Week 1 → Phase 1 (IaC)

## 1) What / How / Why / When / Where
- **What:** Tier-1 flows + vendor adapters; auto-diagnose + package escalations.
- **How:** Terraform → App Service/Functions + APIM → ACA/AKS (small) → Actions + APIM revisions → Monitor/Insights → Entra/Key Vault → docs.
- **Why:** Reduce handle time and ping-pong; standardize Tier-1 excellence.
- **When:** During live tickets and hourly synthetic checks.
- **Where:** Web/mobile; Azure region near site.

## 2) Architecture (Phase 1)
Tech → APIM → App Service/Functions
VNet + subnets + Private Endpoints
PostgreSQL Flexible, Storage(logs)
Key Vault, Log Analytics


## 3) Cloud Services (Phase 1)
- **Azure:** VNet, Subnets, **App Service/Functions**, **API Management**, **PostgreSQL Flexible**, **Storage**, **Log Analytics**, **Key Vault**
- **IaC:** Terraform

## 4) Week 1 Plan — Phase 1
- **Tue:** providers/backend; VNet+subnets.  
- **Wed:** PG Flexible + Storage + Private Endpoints.  
- **Thu:** APIM shell + App Service plan; Log Analytics.  
- **Fri:** Key Vault + outputs + README; tag `v0.1-phase1`.

## 8) Acceptance Criteria
- APIM gateway URL, PG fqdn, KV URI in outputs.

## 9) Troubleshooting Drill
- **APIM→App timeout:** NSG rules, Private DNS zone, health probe.

## 10) Next Phase Preview
- "Camera: No Power" flow stub + adapter contract tests.
