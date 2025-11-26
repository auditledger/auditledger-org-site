# API Reference

Complete API documentation for the Audit Ledger .NET SDK. This reference covers all public classes, methods, and configuration options.

---

## IAuditLedgerService

Main service interface for audit logging operations.

### LogEventAsync

Logs a single audit event.

=== "Signature"

    **Method signature for logging a single audit event:**

    ```csharp
    Task<AuditEventResult> LogEventAsync(
        AuditEvent auditEvent,
        CancellationToken cancellationToken = default
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `auditEvent` | `AuditEvent` | Yes | The audit event to log |
    | `cancellationToken` | `CancellationToken` | No | Optional cancellation token |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `Task<AuditEventResult>` | Result containing event ID, hash, and storage location |

    **AuditEventResult Properties:**

    - `Success` (`bool`) - Indicates if the operation was successful
    - `EventId` (`string`) - Unique identifier of the logged event
    - `StorageLocation` (`string?`) - Where the event was stored
    - `Timestamp` (`DateTime`) - When the event was logged
    - `Hash` (`string?`) - SHA-256 hash of the event
    - `Errors` (`List<string>`) - Any errors that occurred

    [View full class →](classes.md#auditeventresult)

=== "Example"

    **Example usage of logging a single event:**

    ```csharp
    var auditEvent = Soc2Events.UserAuthentication(
        userId: "user123",
        sessionId: "session456",
        result: AuthenticationResult.Success
    );

    var result = await _auditLedger.LogEventAsync(auditEvent);
    if (result.Success)
    {
        Console.WriteLine($"Event logged: {result.EventId}");
    }
    ```

---

### LogEventsAsync

Logs multiple audit events in a batch operation.

=== "Signature"

    **Method signature for logging multiple events in a batch:**

    ```csharp
    Task<BatchAuditEventResult> LogEventsAsync(
        IEnumerable<AuditEvent> auditEvents,
        CancellationToken cancellationToken = default
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `auditEvents` | `IEnumerable<AuditEvent>` | Yes | Collection of audit events to log |
    | `cancellationToken` | `CancellationToken` | No | Optional cancellation token |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `Task<BatchAuditEventResult>` | Batch result with success count and individual results |

    **BatchAuditEventResult Properties:**

    - `Success` (`bool`) - Indicates if all operations were successful
    - `ProcessedCount` (`int`) - Number of events successfully processed
    - `FailedCount` (`int`) - Number of events that failed to process
    - `TotalCount` (`int`) - Total number of events in the batch
    - `Results` (`List<AuditEventResult>`) - Individual results for each event
    - `Errors` (`List<string>`) - Any errors that occurred

    [View full class →](classes.md#batchauditeventresult)

=== "Example"

    **Example usage of batch logging multiple events:**

    ```csharp
    var events = new List<AuditEvent>
    {
        Soc2Events.UserCreated("user1", "admin"),
        Soc2Events.UserCreated("user2", "admin")
    };

    var result = await _auditLedger.LogEventsAsync(events);
    Console.WriteLine($"Processed: {result.ProcessedCount}/{result.TotalCount}");
    ```

---

### VerifyEventAsync

Verifies the cryptographic integrity of an audit event.

=== "Signature"

    **Method signature for verifying event integrity:**

    ```csharp
    Task<VerificationResult> VerifyEventAsync(
        string eventId,
        CancellationToken cancellationToken = default
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `eventId` | `string` | Yes | Unique identifier of the event to verify |
    | `cancellationToken` | `CancellationToken` | No | Optional cancellation token |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `Task<VerificationResult>` | Verification result with validity status and details |

    **VerificationResult Properties:**

    - `IsValid` (`bool`) - Indicates if the event is valid
    - `EventId` (`string`) - Event identifier that was verified
    - `VerifiedAt` (`DateTime`) - When verification was performed
    - `Hash` (`string?`) - Cryptographic hash of the verified event
    - `Errors` (`List<string>`) - Any errors found during verification
    - `VerificationDetails` (`Dictionary<string, object>`) - Additional details

    [View full class →](classes.md#verificationresult)

=== "Example"

    **Example usage of verifying an event:**

    ```csharp
    var verification = await _auditLedger.VerifyEventAsync("evt_123abc");
    if (verification.IsValid)
    {
        Console.WriteLine($"Event verified: {verification.Hash}");
    }
    ```

---

### GetEventsAsync

Retrieves audit events within a specified time range.

=== "Signature"

    **Method signature for querying events by time range:**

    ```csharp
    Task<IEnumerable<AuditEvent>> GetEventsAsync(
        DateTime from,
        DateTime to,
        CancellationToken cancellationToken = default
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `from` | `DateTime` | Yes | Start of time range (UTC) |
    | `to` | `DateTime` | Yes | End of time range (UTC) |
    | `cancellationToken` | `CancellationToken` | No | Optional cancellation token |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `Task<IEnumerable<AuditEvent>>` | Collection of audit events within the specified time range |

    **AuditEvent Properties:**

    - `Id` (`string`) - Unique event identifier
    - `Type` (`string`) - Event type identifier
    - `Time` (`DateTime`) - When the event occurred
    - `Subject` (`string?`) - Subject of the event
    - `Data` (`EventData`) - Event payload with actor, resource, action
    - `Hash` (`string?`) - SHA-256 hash
    - `PreviousEventHash` (`string?`) - Hash of previous event in chain
    - `SequenceNumber` (`long?`) - Position in event chain

    [View full class →](classes.md#auditevent-class)

=== "Example"

    **Example usage of querying events:**

    ```csharp
    var events = await _auditLedger.GetEventsAsync(
        from: DateTime.UtcNow.AddDays(-7),
        to: DateTime.UtcNow
    );

    foreach (var evt in events)
    {
        Console.WriteLine($"{evt.Time}: {evt.Type}");
    }
    ```

---

## Framework Helpers

Type-safe helper methods for creating compliance-specific audit events.

### [SOC 2 Events →](soc2-events.md)

Framework Helper for SOC 2 Trust Service Criteria compliance.

- `UserAuthentication()` - User login/logout events
- `UserCreated()` - User account creation
- `UserDeleted()` - User account deletion
- `DataAccessed()` - Data access logging
- `SystemConfigurationChanged()` - System configuration changes

[View SOC 2 Events Documentation →](soc2-events.md)

---

### [HIPAA Events →](hipaa-events.md)

Framework Helper for HIPAA Privacy and Security Rules compliance.

- `PatientRecordAccessed()` - Patient record access
- `PatientRecordModified()` - Patient record modifications
- `PHIDisclosed()` - Protected Health Information disclosure
- `AccessRevoked()` - Access revocation events
- `AuditLogGenerated()` - Audit log generation

[View HIPAA Events Documentation →](hipaa-events.md)

---

### [PCI DSS Events →](pcidss-events.md)

Framework Helper for PCI DSS Requirements compliance.

- `CardholderDataAccessed()` - Cardholder data access
- `PaymentDataProcessed()` - Payment processing events
- `SecurityIncident()` - Security incident reporting
- `AccessGranted()` - Access control changes
- `SystemMaintenance()` - System maintenance events

[View PCI DSS Events Documentation →](pcidss-events.md)

---

## Next Steps

- **[Classes & Types](classes.md)** - Configuration classes, result types, and data structures
- **[SOC 2 Events](soc2-events.md)** - Complete SOC 2 Framework Helper reference
- **[HIPAA Events](hipaa-events.md)** - Complete HIPAA Framework Helper reference
- **[PCI DSS Events](pcidss-events.md)** - Complete PCI DSS Framework Helper reference
- **[Quick Start](../getting-started/quick-start.md)** - Get started in 5 minutes
- **[Deployment](../deployment/overview.md)** - Deploy to production
