# Core Concepts

Understanding the fundamental concepts behind Audit Ledger will help you use it effectively for SOC 2, HIPAA, and PCI DSS compliance.

---

## :material-shield-lock: Tamper-Proof Audit Logs

Traditional logs can be modified or deleted. Audit Ledger creates **tamper-proof audit logs** using cryptographic event chains where any modification is immediately detectable.

**Key Properties:**

- :material-lock-plus: **Append-Only**: New events can be added, but existing events cannot be modified
- :material-link-variant: **Cryptographically Linked**: Events are connected in a hash chain
- :material-alert-decagram: **Tamper Detection**: Any modification breaks the chain integrity
- :material-certificate: **Compliance Ready**: Meets SOC 2, HIPAA, and PCI DSS requirements

---

## :material-link-lock: Linked Event Chains

Each audit event is cryptographically hashed (SHA-256) and linked to the previous event, creating an unbreakable chain:

```
Event 1 → Hash 1 → Event 2 → Hash 2 → Event 3 → Hash 3
```

Any modification to an event breaks the chain, making tampering immediately detectable.

- :material-check-circle: **Efficient Verification**: Verify any event without loading all events
- :material-alert-circle: **Tamper Detection**: Any change affects the entire chain
- :material-speedometer: **Scalable**: Handle millions of events efficiently

---

## :material-file-document-outline: Event Structure

All Audit Ledger events follow the CloudEvents specification and include:

| Component | Description |
|-----------|-------------|
| **Event Type** | What happened (e.g., `UserCreated`, `DataAccessed`) |
| **Timestamp** | When the event occurred with microsecond precision |
| **Actor** | Who performed the action (user ID, session, IP address) |
| **Resource** | What was acted upon (user, file, database record) |
| **Action** | The operation and its outcome |
| **Framework** | Compliance framework (`SOC2`, `HIPAA`, `PCI_DSS`) |

---

## :material-database: Storage Model

Audit Ledger uses your own cloud storage - you control all audit data:

```
Your Application → Audit Ledger .NET SDK → Your Cloud Storage
                                           ├─ AWS S3
                                           └─ Azure Blob Storage
```

**Benefits:**

- :material-shield-account: **Data Sovereignty**: You control all audit data
- :material-cash-off: **No Vendor Lock-in**: Switch providers anytime
- :material-currency-usd: **Cost Control**: You manage storage costs
- :material-earth: **Compliance**: Meets data residency requirements

**Supported Storage:**

- **AWS S3** - Battle-tested cloud storage with LocalStack support for local development
- **Azure Blob Storage** - Azure-native storage with Azurite support for local development

**Coming Soon:** GCP Storage, EventStore

---

## :material-shield-check: Framework Helpers

Audit Ledger provides type-safe helpers for SOC 2, HIPAA, and PCI DSS compliance:

```csharp
// SOC 2 - User authentication
var soc2Event = Soc2Events.UserLogin(
    userId: "user123",
    ipAddress: "192.168.1.100",
    success: true
);

// HIPAA - Patient record access
var hipaaEvent = HipaaEvents.PatientRecordAccessed(
    patientId: "patient-456",
    actorUserId: "doctor-123",
    accessReason: "treatment"
);

// PCI DSS - Payment data access
var pciEvent = PciDssEvents.CardholderDataAccessed(
    maskedPan: "****-****-****-1234",
    merchantId: "MERCH_001"
);
```

**Benefits:**

- :material-check-decagram: **Type Safety**: Compile-time validation with IntelliSense
- :material-code-braces: **90% Less Code**: Compared to manual event creation
- :material-lightbulb: **Best Practices**: Framework requirements automatically included

---

## :material-map: Next Steps

- :material-rocket-launch: **[Quick Start](quick-start.md)** - Get up and running in 5 minutes
- :material-api: **[API Reference](../api/overview.md)** - Explore the complete API
- :material-cloud-upload: **[Deployment Guide](../deployment/overview.md)** - Deploy to production

