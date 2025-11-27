# Quick Start

Get Audit Ledger running in 5 minutes and log your first compliance event.

---

## :material-download: Step 1: Install the SDK

Install the Audit Ledger NuGet package:

=== ".NET CLI"

    ```bash
    dotnet add package AuditLedger
    ```

=== "Package Manager"

    ```powershell
    Install-Package AuditLedger
    ```

=== "PackageReference"

    ```xml
    <PackageReference Include="AuditLedger" Version="1.0.0" />
    ```

**Requirements:** .NET 9.0 or later

---

## :material-cloud: Step 2: Choose Your Storage

Audit Ledger stores events directly in your cloud storage - you control everything.

=== "AWS S3"

    **Best for:** AWS users, S3-compatible storage, enterprise scale

    - Battle-tested cloud storage
    - Terraform module for automated setup
    - LocalStack support for local development

    [View Terraform Module :material-arrow-right:](../deployment/overview.md){ .md-button }

=== "Azure Blob Storage"

    **Best for:** Azure users, Microsoft ecosystem

    - Azure-native storage solution
    - Terraform module for automated setup
    - Azurite support for local development

    [View Terraform Module :material-arrow-right:](../deployment/overview.md){ .md-button }

---

## :material-cog: Step 3: Configure the SDK

Add Audit Ledger to your application's dependency injection:

=== "AWS S3"

    ```csharp
    using AuditLedger;

    var builder = WebApplication.CreateBuilder(args);

    // Configure Audit Ledger with AWS S3
    builder.Services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AwsS3;
        options.Storage.AwsS3 = new AwsS3Options
        {
            BucketName = "my-audit-logs",
            Region = "us-west-2"
        };
        options.Compliance.OrganizationId = "your-company-id";
    });

    var app = builder.Build();
    app.Run();
    ```

    !!! warning "Required Configuration"
        **`OrganizationId` is required** - Events will fail validation without it. This identifier is used for data isolation and event chain integrity.

    !!! tip "IAM Permissions Required"
        Your application needs `s3:PutObject`, `s3:GetObject`, and `s3:ListBucket` permissions.

=== "Azure Blob Storage"

    ```csharp
    using AuditLedger;

    var builder = WebApplication.CreateBuilder(args);

    // Configure Audit Ledger with Azure Blob
    builder.Services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AzureBlob;
        options.Storage.AzureBlob = new AzureBlobOptions
        {
            ContainerName = "auditlogs",
            AccountName = "mystorageaccount"
        };
        options.Compliance.OrganizationId = "your-company-id";
    });

    var app = builder.Build();
    app.Run();
    ```

    !!! warning "Required Configuration"
        **`OrganizationId` is required** - Events will fail validation without it. This identifier is used for data isolation and event chain integrity.

    !!! tip "Connection String Security"
        Store connection strings in Azure Key Vault or environment variables. Production deployments should use DefaultAzureCredential (managed identity).

---

## :material-file-document-edit: Step 4: Log Your First Event

Use Framework Helpers to log compliance events with type safety:

```csharp
using AuditLedger;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly IAuditLedgerService _auditLedger;

    public AuthController(IAuditLedgerService auditLedger)
    {
        _auditLedger = auditLedger;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var result = await AuthenticateUser(request);

        // Log SOC 2 compliant authentication event
        var auditEvent = Soc2Events.UserLogin(
            userId: result.UserId,
            ipAddress: HttpContext.Connection.RemoteIpAddress?.ToString(),
            userAgent: Request.Headers["User-Agent"],
            success: result.Success,
            mfaUsed: result.MfaUsed
        );

        // Event is hashed, linked, and stored automatically
        await _auditLedger.LogAsync(auditEvent);

        return Ok(result);
    }
}
```

!!! success "Event Logged!"
    The event is now stored in your cloud storage with:

    - :material-check: Cryptographic hash (SHA-256)
    - :material-link-variant: Link to previous event
    - :material-clock-outline: Microsecond timestamp
    - :material-shield-check: SOC 2 compliance metadata

---

## :material-shield-check: Framework Helpers

Log events for different compliance frameworks:

```csharp
// SOC 2 - User account changes
var soc2Event = Soc2Events.UserCreated(
    userId: "user123",
    actorUserId: "admin",
    sessionId: session.Id
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

await _auditLedger.LogAsync(auditEvent);
```

---

## :material-rocket-launch: Next Steps

- :material-book-open-variant: **[Core Concepts](concepts.md)** - Understand event chains and tamper detection
- :material-api: **[API Reference](../api/overview.md)** - Explore all Framework Helpers and methods
- :material-terraform: **[Terraform Modules](../deployment/overview.md)** - Automate infrastructure setup
- :material-github: **[GitHub](https://github.com/auditledger)** - View source code and contribute

---

!!! success "Ready for Compliance!"
    You've successfully set up Audit Ledger and logged your first audit event. Your data stays on your infrastructure with complete sovereignty. **Pass your next audit with confidence!** ✨