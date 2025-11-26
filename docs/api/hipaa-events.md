# HIPAA Events

Framework Helper for HIPAA Privacy and Security Rules compliance events.

---

## PatientRecordAccessed

Creates a patient record access event for HIPAA 45 CFR 164.530 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent PatientRecordAccessed(
        string patientId,
        string actorUserId,
        string? actorRole = null,
        string? department = null,
        string? accessReason = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `patientId` | `string` | Yes | Patient record identifier |
    | `actorUserId` | `string` | Yes | ID of user accessing the record |
    | `actorRole` | `string?` | No | Role of actor (e.g., "Physician", "Nurse") |
    | `department` | `string?` | No | Department of actor (e.g., "Cardiology") |
    | `accessReason` | `string?` | No | Reason for access (default: "treatment") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | HIPAA compliant patient record access event |

    **Event Details:**

    - **Event Type:** `io.auditledger.hipaa.privacy.patient_record.accessed`
    - **Privacy Rule:** 45 CFR 164.530
    - **Security Rule:** 45 CFR 164.312
    - **Minimum Necessary:** true
    - **Access Reason:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var patientEvent = HipaaEvents.PatientRecordAccessed(
        patientId: "patient-456",
        actorUserId: "doctor-123",
        actorRole: "Physician",
        department: "Cardiology",
        accessReason: "treatment",
        sessionId: "session789",
        ipAddress: "192.168.1.1"
    );

    await _auditLedger.LogEventAsync(patientEvent);
    ```

---

## PatientRecordModified

Creates a patient record modification event for HIPAA 45 CFR 164.530 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent PatientRecordModified(
        string patientId,
        string actorUserId,
        string operation,
        string? actorRole = null,
        string? department = null,
        string? modificationReason = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `patientId` | `string` | Yes | Patient record identifier |
    | `actorUserId` | `string` | Yes | ID of user modifying the record |
    | `operation` | `string` | Yes | Operation type (e.g., "update", "create", "delete") |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `modificationReason` | `string?` | No | Reason for modification (default: "treatment") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | HIPAA compliant patient record modification event |

    **Event Details:**

    - **Event Type:** `io.auditledger.hipaa.privacy.patient_record.modified`
    - **Privacy Rule:** 45 CFR 164.530
    - **Security Rule:** 45 CFR 164.312
    - **Minimum Necessary:** true
    - **Modification Reason:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var modifyEvent = HipaaEvents.PatientRecordModified(
        patientId: "patient-456",
        actorUserId: "doctor-123",
        operation: "update",
        actorRole: "Physician",
        department: "Cardiology",
        modificationReason: "treatment",
        sessionId: "session789"
    );

    await _auditLedger.LogEventAsync(modifyEvent);
    ```

---

## PHIDisclosed

Creates a Protected Health Information disclosure event for HIPAA 45 CFR 164.502 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent PHIDisclosed(
        string patientId,
        string actorUserId,
        string disclosureType,
        string? recipientType = null,
        string? actorRole = null,
        string? department = null,
        string? disclosureReason = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `patientId` | `string` | Yes | Patient identifier |
    | `actorUserId` | `string` | Yes | ID of user disclosing PHI |
    | `disclosureType` | `string` | Yes | Type of disclosure (e.g., "treatment", "payment", "healthcare_operations") |
    | `recipientType` | `string?` | No | Type of recipient (e.g., "provider", "insurer") |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `disclosureReason` | `string?` | No | Reason for disclosure (default: "treatment") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | HIPAA compliant PHI disclosure event |

    **Event Details:**

    - **Event Type:** `io.auditledger.hipaa.privacy.phi.disclosed`
    - **Privacy Rule:** 45 CFR 164.502
    - **Disclosure Type:** Stored in framework data
    - **Recipient Type:** Stored in framework data
    - **Disclosure Reason:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var disclosureEvent = HipaaEvents.PHIDisclosed(
        patientId: "patient-456",
        actorUserId: "doctor-123",
        disclosureType: "treatment",
        recipientType: "provider",
        actorRole: "Physician",
        department: "Cardiology",
        disclosureReason: "consultation"
    );

    await _auditLedger.LogEventAsync(disclosureEvent);
    ```

---

## AccessRevoked

Creates an access revocation event for HIPAA 45 CFR 164.530 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent AccessRevoked(
        string patientId,
        string actorUserId,
        string? revokedUserId = null,
        string? actorRole = null,
        string? department = null,
        string? revocationReason = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `patientId` | `string` | Yes | Patient record identifier |
    | `actorUserId` | `string` | Yes | ID of user revoking access |
    | `revokedUserId` | `string?` | No | ID of user whose access is revoked |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `revocationReason` | `string?` | No | Reason for revocation (default: "policy_violation") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | HIPAA compliant access revocation event |

    **Event Details:**

    - **Event Type:** `io.auditledger.hipaa.privacy.access.revoked`
    - **Privacy Rule:** 45 CFR 164.530
    - **Revoked User ID:** Stored in framework data
    - **Revocation Reason:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var revokeEvent = HipaaEvents.AccessRevoked(
        patientId: "patient-456",
        actorUserId: "admin-789",
        revokedUserId: "nurse-123",
        actorRole: "Administrator",
        department: "IT",
        revocationReason: "employment_terminated"
    );

    await _auditLedger.LogEventAsync(revokeEvent);
    ```

---

## AuditLogGenerated

Creates an audit log generation event for HIPAA 45 CFR 164.530 compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent AuditLogGenerated(
        string actorUserId,
        string logType,
        string? actorRole = null,
        string? department = null,
        string? sessionId = null,
        string? ipAddress = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `actorUserId` | `string` | Yes | ID of user generating the audit log |
    | `logType` | `string` | Yes | Type of audit log (e.g., "access_log", "disclosure_log") |
    | `actorRole` | `string?` | No | Role of actor |
    | `department` | `string?` | No | Department of actor |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | HIPAA compliant audit log generation event |

    **Event Details:**

    - **Event Type:** `io.auditledger.hipaa.privacy.audit_log.generated`
    - **Privacy Rule:** 45 CFR 164.530
    - **Log Type:** Stored in framework data
    - **Compliance Requirement:** audit_trail

=== "Example"

    **Example usage:**

    ```csharp
    var auditEvent = HipaaEvents.AuditLogGenerated(
        actorUserId: "admin-789",
        logType: "access_log",
        actorRole: "Administrator",
        department: "IT"
    );

    await _auditLedger.LogEventAsync(auditEvent);
    ```

---

## Next Steps

- **[SOC 2 Events](soc2-events.md)** - SOC 2 Framework Helper reference
- **[PCI DSS Events](pcidss-events.md)** - PCI DSS Framework Helper reference
- **[API Overview](overview.md)** - Complete API reference
- **[Quick Start](../getting-started/quick-start.md)** - Get started in 5 minutes

