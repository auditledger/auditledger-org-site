# Classes & Types

Reference documentation for configuration classes, result types, and data structures.

---

## Configuration

Configuration classes for SDK setup and storage providers.

### AuditLedgerOptions

Main configuration class for the SDK.

=== "Signature"

    **Class definition:**

    ```csharp
    public class AuditLedgerOptions
    {
        public StorageOptions Storage { get; set; }
        public ComplianceOptions Compliance { get; set; }
        public DashboardsOptions? Dashboards { get; set; }
        public SigningOptions? Signing { get; set; }
    }
    ```

=== "Properties"

    | Property | Type | Required | Description |
    |----------|------|----------|-------------|
    | `Storage` | `StorageOptions` | Yes | Storage provider configuration |
    | `Compliance` | `ComplianceOptions` | Yes | Compliance framework settings |
    | `Dashboards` | `DashboardsOptions?` | No | Dashboard and monitoring configuration |
    | `Signing` | `SigningOptions?` | No | Digital signature configuration |

=== "Example"

    **Example usage:**

    ```csharp
    builder.Services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AwsS3;
        options.Storage.AwsS3 = new AwsS3Options
        {
            BucketName = "my-audit-logs",
            Region = "us-east-1"
        };
        options.Compliance.OrganizationId = "my-company-123";
    });
    ```

---

### StorageOptions

Storage provider configuration.

=== "Signature"

    **Class definition:**

    ```csharp
    public class StorageOptions
    {
        public StorageProvider Provider { get; set; }
        public string ConnectionString { get; set; }
        public string ContainerName { get; set; }
        public AwsS3Options? AwsS3 { get; set; }
        public AzureBlobOptions? AzureBlob { get; set; }
        public GcpStorageOptions? GcpStorage { get; set; }
        public EventStoreOptions? EventStore { get; set; }
    }
    ```

=== "Properties"

    | Property | Type | Required | Description |
    |----------|------|----------|-------------|
    | `Provider` | `StorageProvider` | Yes | Storage provider type (AwsS3, AzureBlob, etc.) |
    | `ConnectionString` | `string` | Depends | Connection string for storage provider |
    | `ContainerName` | `string` | Depends | Container or bucket name |
    | `AwsS3` | `AwsS3Options?` | No | AWS S3-specific configuration |
    | `AzureBlob` | `AzureBlobOptions?` | No | Azure Blob-specific configuration |
    | `GcpStorage` | `GcpStorageOptions?` | No | GCP Storage configuration (roadmap) |
    | `EventStore` | `EventStoreOptions?` | No | EventStore configuration (roadmap) |

=== "Example"

    **Example usage:**

    ```csharp
    options.Storage.Provider = StorageProvider.AwsS3;
    options.Storage.AwsS3 = new AwsS3Options
    {
        BucketName = "my-audit-logs",
        Region = "us-west-2"
    };
    ```

---

### StorageProvider Enum

Available storage providers.

=== "Signature"

    **Enum definition:**

    ```csharp
    public enum StorageProvider
    {
        AwsS3,          // ✅ Available
        AzureBlob,      // ✅ Available
        GcpStorage,     // 📋 Roadmap
        EventStore      // 📋 Roadmap
    }
    ```

=== "Values"

    | Value | Status | Description |
    |-------|--------|-------------|
    | `AwsS3` | ✅ Available | Amazon S3 storage provider |
    | `AzureBlob` | ✅ Available | Azure Blob Storage provider |
    | `GcpStorage` | 📋 Roadmap | Google Cloud Storage (coming soon) |
    | `EventStore` | 📋 Roadmap | EventStore database (coming soon) |

=== "Example"

    **Example usage:**

    ```csharp
    builder.Services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AwsS3;
        options.Storage.AwsS3 = new AwsS3Options
        {
            BucketName = "my-audit-logs",
            Region = "us-east-1"
        };
    });
    ```

---

### ComplianceOptions

Compliance framework configuration.

=== "Signature"

    **Class definition:**

    ```csharp
    public class ComplianceOptions
    {
        public string OrganizationId { get; set; }
        public string? Environment { get; set; }
    }
    ```

=== "Properties"

    | Property | Type | Required | Description |
    |----------|------|----------|-------------|
    | `OrganizationId` | `string` | **Yes** | Unique organization identifier for data isolation and event chain integrity |
    | `Environment` | `string?` | No | Environment name (e.g., "Production", "Staging", "Development") |

=== "Example"

    **Example usage:**

    ```csharp
    options.Compliance.OrganizationId = "my-company-123";
    options.Compliance.Environment = "Production";
    ```

---

## Result Types

Return types for SDK operations.

### AuditEventResult

Result of logging a single audit event.

=== "Signature"

    **Class definition:**

    ```csharp
    public class AuditEventResult
    {
        public bool Success { get; set; }
        public string EventId { get; set; }
        public string? StorageLocation { get; set; }
        public DateTime Timestamp { get; set; }
        public string? Hash { get; set; }
        public List<string> Errors { get; set; }
    }
    ```

=== "Properties"

    | Property | Type | Description |
    |----------|------|-------------|
    | `Success` | `bool` | Indicates if the operation was successful |
    | `EventId` | `string` | Unique identifier of the logged event |
    | `StorageLocation` | `string?` | Where the event was stored |
    | `Timestamp` | `DateTime` | When the event was logged |
    | `Hash` | `string?` | SHA-256 hash of the event |
    | `Errors` | `List<string>` | Any errors that occurred during logging |

=== "Example"

    **Example usage:**

    ```csharp
    var result = await _auditLedger.LogEventAsync(auditEvent);
    if (result.Success)
    {
        Console.WriteLine($"Event ID: {result.EventId}");
        Console.WriteLine($"Hash: {result.Hash}");
        Console.WriteLine($"Location: {result.StorageLocation}");
    }
    else
    {
        foreach (var error in result.Errors)
        {
            Console.WriteLine($"Error: {error}");
        }
    }
    ```

---

### BatchAuditEventResult

Result of logging multiple audit events.

=== "Signature"

    **Class definition:**

    ```csharp
    public class BatchAuditEventResult
    {
        public bool Success { get; set; }
        public int ProcessedCount { get; set; }
        public int FailedCount { get; set; }
        public int TotalCount { get; set; }
        public List<AuditEventResult> Results { get; set; }
        public List<string> Errors { get; set; }
    }
    ```

=== "Properties"

    | Property | Type | Description |
    |----------|------|-------------|
    | `Success` | `bool` | Indicates if all operations were successful |
    | `ProcessedCount` | `int` | Number of events successfully processed |
    | `FailedCount` | `int` | Number of events that failed to process |
    | `TotalCount` | `int` | Total number of events in the batch |
    | `Results` | `List<AuditEventResult>` | Individual results for each event |
    | `Errors` | `List<string>` | Any errors that occurred during batch processing |

=== "Example"

    **Example usage:**

    ```csharp
    var result = await _auditLedger.LogEventsAsync(events);
    Console.WriteLine($"Processed: {result.ProcessedCount}/{result.TotalCount}");
    Console.WriteLine($"Failed: {result.FailedCount}");

    foreach (var individualResult in result.Results)
    {
        if (!individualResult.Success)
        {
            Console.WriteLine($"Failed event: {individualResult.Errors[0]}");
        }
    }
    ```

---

### VerificationResult

Result of event integrity verification.

=== "Signature"

    **Class definition:**

    ```csharp
    public class VerificationResult
    {
        public bool IsValid { get; set; }
        public string EventId { get; set; }
        public DateTime VerifiedAt { get; set; }
        public string? Hash { get; set; }
        public List<string> Errors { get; set; }
        public Dictionary<string, object> VerificationDetails { get; set; }
    }
    ```

=== "Properties"

    | Property | Type | Description |
    |----------|------|-------------|
    | `IsValid` | `bool` | Indicates if the event is valid |
    | `EventId` | `string` | Event identifier that was verified |
    | `VerifiedAt` | `DateTime` | When verification was performed |
    | `Hash` | `string?` | Cryptographic hash of the verified event |
    | `Errors` | `List<string>` | Any errors found during verification |
    | `VerificationDetails` | `Dictionary<string, object>` | Additional verification details |

=== "Example"

    **Example usage:**

    ```csharp
    var verification = await _auditLedger.VerifyEventAsync("evt_123abc");
    if (verification.IsValid)
    {
        Console.WriteLine($"Event verified: {verification.Hash}");
        Console.WriteLine($"Verified at: {verification.VerifiedAt}");
    }
    else
    {
        Console.WriteLine("Verification failed:");
        foreach (var error in verification.Errors)
        {
            Console.WriteLine($"  - {error}");
        }
    }
    ```

---

## AuditEvent Class

Represents an immutable audit event following CloudEvents specification.

=== "Signature"

    **Class definition:**

    ```csharp
    public class AuditEvent
    {
        public string SpecVersion { get; set; }           // CloudEvents version
        public string Type { get; set; }                  // Event type identifier
        public string Source { get; set; }                // Event source
        public string Id { get; set; }                    // Unique event ID
        public DateTime Time { get; set; }                // Event timestamp (UTC)
        public string DataContentType { get; set; }       // Content type
        public string? Subject { get; set; }              // Event subject
        public string? DataSchema { get; set; }           // Schema URL
        public EventData Data { get; set; }               // Event payload

        // Cryptographic integrity fields
        public string? Hash { get; set; }                 // SHA-256 hash
        public string? PreviousEventHash { get; set; }    // Previous event hash
        public long? SequenceNumber { get; set; }         // Chain sequence number
        public string? Signature { get; set; }            // Digital signature
        public string? StorageLocation { get; set; }      // Storage path
        public DateTime CreatedAt { get; set; }           // Creation timestamp
    }
    ```

=== "Properties"

    | Property | Type | Description |
    |----------|------|-------------|
    | `SpecVersion` | `string` | CloudEvents specification version (1.0) |
    | `Type` | `string` | Event type identifier (e.g., `io.auditledger.soc2.security.user.created`) |
    | `Source` | `string` | Context where event occurred (service URL) |
    | `Id` | `string` | Unique event identifier |
    | `Time` | `DateTime` | When the event occurred (UTC) |
    | `DataContentType` | `string` | Content type of data (default: "application/json") |
    | `Subject` | `string?` | Subject of the event (e.g., user ID) |
    | `DataSchema` | `string?` | Schema URL for data validation |
    | `Data` | `EventData` | Event payload with actor, resource, action details |
    | `Hash` | `string?` | SHA-256 cryptographic hash |
    | `PreviousEventHash` | `string?` | Hash of previous event in chain |
    | `SequenceNumber` | `long?` | Position in event chain |
    | `Signature` | `string?` | HMAC-SHA256 or RSA signature |
    | `StorageLocation` | `string?` | Where event is stored |
    | `CreatedAt` | `DateTime` | Timestamp when event was created |

=== "Example"

    **Example usage:**

    ```csharp
    // Events are typically created using Framework Helpers
    var auditEvent = Soc2Events.UserCreated(
        userId: "user123",
        actorUserId: "admin"
    );

    // Access event properties
    Console.WriteLine($"Event ID: {auditEvent.Id}");
    Console.WriteLine($"Event Type: {auditEvent.Type}");
    Console.WriteLine($"Timestamp: {auditEvent.Time}");

    // After logging, additional fields are populated
    var result = await _auditLedger.LogEventAsync(auditEvent);
    if (result.Success)
    {
        Console.WriteLine($"Hash: {auditEvent.Hash}");
        Console.WriteLine($"Sequence: {auditEvent.SequenceNumber}");
    }
    ```

---

## Enums

### AuthenticationResult

Authentication result enumeration.

=== "Signature"

    **Enum definition:**

    ```csharp
    public enum AuthenticationResult
    {
        Success,    // Authentication successful
        Failure,    // Authentication failed
        Pending     // Authentication pending
    }
    ```

=== "Values"

    | Value | Description |
    |-------|-------------|
    | `Success` | Authentication was successful |
    | `Failure` | Authentication failed |
    | `Pending` | Authentication is pending |

=== "Example"

    **Example usage:**

    ```csharp
    var authEvent = Soc2Events.UserAuthentication(
        userId: "user123",
        sessionId: "session456",
        result: AuthenticationResult.Success
    );

    await _auditLedger.LogEventAsync(authEvent);
    ```

---

## Next Steps

- **[API Overview](overview.md)** - Main service interface and methods
- **[SOC 2 Events](soc2-events.md)** - SOC 2 Framework Helper reference
- **[HIPAA Events](hipaa-events.md)** - HIPAA Framework Helper reference
- **[PCI DSS Events](pcidss-events.md)** - PCI DSS Framework Helper reference

