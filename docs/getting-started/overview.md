# Overview

Audit Ledger is a free, open-source .NET SDK that provides **tamper-proof audit logging and compliance reporting** for SOC 2, HIPAA, and PCI DSS requirements. Built for regulated companies that need **complete data sovereignty**—your audit data stays on your infrastructure (AWS S3 or Azure Blob Storage), with no external dependencies or API keys required. Deploy with Terraform modules for automated infrastructure provisioning.

---

## :material-cog-outline: How Audit Ledger Works

Audit Ledger integrates into your .NET application as a library. You install the SDK via NuGet, configure it to use your chosen cloud storage provider (AWS S3 or Azure Blob Storage), and start logging compliance events. The SDK handles all cryptographic operations, event chaining, and storage operations—your application just calls the logging methods. Use our Terraform modules to provision and configure the storage infrastructure automatically, ensuring proper security policies, encryption, and lifecycle management are in place from day one.

**:material-language-csharp: Free .NET SDK**

- .NET 9.0 SDK with dependency injection and async/await patterns
- Choose your storage provider: AWS S3 or Azure Blob Storage
- Events are hashed, linked in chains, and stored with tamper detection
- No API keys required - direct SDK to cloud storage integration

**:material-terraform: Terraform Infrastructure Automation**

- Terraform modules for AWS S3 setup
- Terraform modules for Azure Blob Storage setup
- Automated provisioning with security policies
- LocalStack and Azurite support for local development
- Version-controlled infrastructure as code

---

## :material-lightbulb-on: Key Benefits

- :material-package-variant: **Free .NET SDK**: Start with AWS S3 or Azure Blob - no API keys required
- :material-check-decagram: **Type Safety**: Strong typing prevents common logging mistakes
- :material-shield-lock: **Data Sovereignty**: All audit data stays on your infrastructure
- :material-clipboard-check: **Unified Compliance**: One platform for SOC 2, HIPAA, and PCI DSS
- :material-source-branch: **Event Sourcing**: Complete audit trails with EventStore integration (coming soon)

---

## :material-shield-check: Supported Compliance Frameworks

| Framework | Focus | Key Features |
|-----------|-------|--------------|
| :material-shield-account: **SOC 2** | System controls | Trust Service Criteria, Security controls, Availability monitoring |
| :material-hospital-box: **HIPAA** | Healthcare data protection | PHI access logging, Patient rights, Business Associate tracking |
| :material-credit-card-check: **PCI DSS** | Financial data protection | Cardholder data access logging, Payment processing controls, Security monitoring |

---

## :material-map: Next Steps

- :material-rocket-launch: **[Quick Start](quick-start.md)** - Get Audit Ledger SDK running in 5 minutes
- :material-book-open-variant: **[Core Concepts](concepts.md)** - Understand immutable logs, linked chains, and event sourcing
- :material-api: **[API Reference](../api/overview.md)** - Explore the complete API documentation
