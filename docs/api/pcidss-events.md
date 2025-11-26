# PCI DSS Events

Framework Helper for PCI DSS Requirements compliance events.

---

## CardholderDataAccessed

Creates a cardholder data access event for PCI DSS Requirement 10.2.1 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent CardholderDataAccessed(
        string transactionId,
        string merchantId,
        string actorUserId,
        string? actorRole = null,
        string? department = null,
        string? accessType = null,
        string? maskedPan = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `transactionId` | `string` | Yes | Transaction identifier |
    | `merchantId` | `string` | Yes | Merchant identifier |
    | `actorUserId` | `string` | Yes | ID of user accessing cardholder data |
    | `actorRole` | `string?` | No | Role of actor (e.g., "Payment Processor") |
    | `department` | `string?` | No | Department of actor |
    | `accessType` | `string?` | No | Type of access (default: "read") |
    | `maskedPan` | `string?` | No | Masked PAN (default: "****-****-****-****") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | PCI DSS compliant cardholder data access event |

    **Event Details:**

    - **Event Type:** `io.auditledger.pcidss.security.cardholder_data.accessed`
    - **Requirement:** PCI DSS 10.2
    - **Control ID:** 10.2.1
    - **Data Type:** CardholderData
    - **Merchant ID:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var cardEvent = PciDssEvents.CardholderDataAccessed(
        transactionId: "txn-123",
        merchantId: "MERCH_001",
        actorUserId: "processor-456",
        actorRole: "Payment Processor",
        accessType: "read",
        maskedPan: "****-****-****-1234",
        sessionId: "session789"
    );

    await _auditLedger.LogEventAsync(cardEvent);
    ```

---

## PaymentDataProcessed

Creates a payment data processing event for PCI DSS Requirement 10.2.2 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent PaymentDataProcessed(
        string transactionId,
        string merchantId,
        string actorUserId,
        string processingStage,
        string outcome,
        string? actorRole = null,
        string? department = null,
        string? cardType = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `transactionId` | `string` | Yes | Transaction identifier |
    | `merchantId` | `string` | Yes | Merchant identifier |
    | `actorUserId` | `string` | Yes | ID of user processing payment |
    | `processingStage` | `string` | Yes | Processing stage (e.g., "authorize", "capture", "refund") |
    | `outcome` | `string` | Yes | Processing outcome (e.g., "success", "failure") |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `cardType` | `string?` | No | Card type (default: "Unknown") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | PCI DSS compliant payment data processing event |

    **Event Details:**

    - **Event Type:** `io.auditledger.pcidss.security.payment_data.processed`
    - **Requirement:** PCI DSS 10.2
    - **Control ID:** 10.2.2
    - **Data Type:** PaymentData
    - **Merchant ID:** Stored in framework data
    - **Processing Stage:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var paymentEvent = PciDssEvents.PaymentDataProcessed(
        transactionId: "txn-123",
        merchantId: "MERCH_001",
        actorUserId: "processor-456",
        processingStage: "authorize",
        outcome: "success",
        actorRole: "Payment Processor",
        cardType: "Visa"
    );

    await _auditLedger.LogEventAsync(paymentEvent);
    ```

---

## SecurityIncident

Creates a security incident event for PCI DSS Requirement 12.10.1 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent SecurityIncident(
        string incidentId,
        string actorUserId,
        string incidentType,
        string severity,
        string? description = null,
        string? actorRole = null,
        string? department = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `incidentId` | `string` | Yes | Incident identifier |
    | `actorUserId` | `string` | Yes | ID of user reporting incident |
    | `incidentType` | `string` | Yes | Type of incident (e.g., "unauthorized_access", "data_breach") |
    | `severity` | `string` | Yes | Severity level (e.g., "low", "medium", "high", "critical") |
    | `description` | `string?` | No | Incident description |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | PCI DSS compliant security incident event |

    **Event Details:**

    - **Event Type:** `io.auditledger.pcidss.security.incident.occurred`
    - **Requirement:** PCI DSS 12.10
    - **Control ID:** 12.10.1
    - **Incident Type:** Stored in framework data
    - **Severity:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var incidentEvent = PciDssEvents.SecurityIncident(
        incidentId: "incident-789",
        actorUserId: "security-admin",
        incidentType: "unauthorized_access",
        severity: "high",
        description: "Attempted unauthorized access to payment data",
        actorRole: "Security Administrator",
        department: "Security"
    );

    await _auditLedger.LogEventAsync(incidentEvent);
    ```

---

## AccessGranted

Creates an access granted event for PCI DSS Requirement 7.1.1 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent AccessGranted(
        string resourceId,
        string resourceType,
        string actorUserId,
        string targetUserId,
        string? actorRole = null,
        string? department = null,
        string? accessLevel = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `resourceId` | `string` | Yes | Resource identifier |
    | `resourceType` | `string` | Yes | Resource type (e.g., "PaymentSystem", "Database") |
    | `actorUserId` | `string` | Yes | ID of user granting access |
    | `targetUserId` | `string` | Yes | ID of user receiving access |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `accessLevel` | `string?` | No | Access level granted (default: "standard") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | PCI DSS compliant access granted event |

    **Event Details:**

    - **Event Type:** `io.auditledger.pcidss.security.access.granted`
    - **Requirement:** PCI DSS 7.1
    - **Control ID:** 7.1.1
    - **Target User ID:** Stored in framework data
    - **Access Level:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var accessEvent = PciDssEvents.AccessGranted(
        resourceId: "payment-system",
        resourceType: "PaymentSystem",
        actorUserId: "admin-123",
        targetUserId: "processor-456",
        actorRole: "System Administrator",
        accessLevel: "read_write"
    );

    await _auditLedger.LogEventAsync(accessEvent);
    ```

---

## SystemMaintenance

Creates a system maintenance event for PCI DSS Requirement 6.1.1 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent SystemMaintenance(
        string systemId,
        string actorUserId,
        string maintenanceType,
        string? description = null,
        string? actorRole = null,
        string? department = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `systemId` | `string` | Yes | System identifier |
    | `actorUserId` | `string` | Yes | ID of user performing maintenance |
    | `maintenanceType` | `string` | Yes | Type of maintenance (e.g., "patch", "update", "configuration") |
    | `description` | `string?` | No | Maintenance description |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | PCI DSS compliant system maintenance event |

    **Event Details:**

    - **Event Type:** `io.auditledger.pcidss.security.system.maintenance`
    - **Requirement:** PCI DSS 6.1
    - **Control ID:** 6.1.1
    - **Maintenance Type:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var maintenanceEvent = PciDssEvents.SystemMaintenance(
        systemId: "payment-gateway",
        actorUserId: "devops-123",
        maintenanceType: "patch",
        description: "Applied security patch CVE-2024-1234",
        actorRole: "DevOps Engineer",
        department: "Engineering"
    );

    await _auditLedger.LogEventAsync(maintenanceEvent);
    ```

---

## Next Steps

- **[SOC 2 Events](soc2-events.md)** - SOC 2 Framework Helper reference
- **[HIPAA Events](hipaa-events.md)** - HIPAA Framework Helper reference
- **[API Overview](overview.md)** - Complete API reference
- **[Quick Start](../getting-started/quick-start.md)** - Get started in 5 minutes

