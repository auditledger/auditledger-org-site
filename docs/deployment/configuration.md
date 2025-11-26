# Configuration

Complete configuration guide for Audit Ledger SDK.

## Basic Configuration

### Minimum Required Setup

```csharp
services.AddAuditLedger(options =>
{
    options.Storage.Provider = StorageProvider.AwsS3;
    options.Storage.AwsS3 = new AwsS3Options
    {
        BucketName = "my-audit-logs",
        Region = "us-east-1"
    };
    options.Compliance.OrganizationId = "your-company-id";  // Required
});
```

!!! warning "Required Configuration"
    **`OrganizationId` is required** - Events will fail validation without it. This identifier is used for data isolation and event chain integrity.

## Storage Configuration

### AWS S3

```csharp
options.Storage.Provider = StorageProvider.AwsS3;
options.Storage.AwsS3 = new AwsS3Options
{
    BucketName = "audit-logs",
    Region = "us-east-1"
    // IAM roles are used automatically when running on AWS infrastructure
    // For local development, use LocalStack or explicit credentials via environment variables
};
options.Compliance.OrganizationId = "your-company-id";
```

!!! tip "IAM Authentication"
    When running on AWS (EC2, ECS, Lambda), IAM roles are automatically used. No credentials needed in code.

### Azure Blob Storage

```csharp
options.Storage.Provider = StorageProvider.AzureBlob;
options.Storage.AzureBlob = new AzureBlobOptions
{
    ContainerName = "audit-logs",
    AccountName = "mystorageaccount"
    // Use DefaultAzureCredential for managed identity (recommended)
    // Or connection string for local development
};
options.Compliance.OrganizationId = "your-company-id";
```

!!! tip "Managed Identity"
    When running on Azure (App Service, Functions, AKS), managed identities are automatically used via `DefaultAzureCredential`.

## Compliance Configuration

### Organization ID

The `OrganizationId` is required and used for:
- Data isolation between organizations
- Event chain integrity
- Storage path organization

```csharp
options.Compliance.OrganizationId = "your-company-id";
```

### Environment

Optionally specify the environment for better organization:

```csharp
options.Compliance.Environment = "Production";  // Optional: "Development", "Staging", "Production"
```

## Environment-Specific Configuration

### Development

```csharp
if (builder.Environment.IsDevelopment())
{
    services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AwsS3;
        options.Storage.AwsS3 = new AwsS3Options
        {
            BucketName = "dev-audit-logs",
            Region = "us-east-1"
        };
        options.Compliance.OrganizationId = "your-company-id";
        options.Compliance.Environment = "Development";
    });
}
```

### Production

```csharp
if (builder.Environment.IsProduction())
{
    services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AwsS3;
        options.Storage.AwsS3 = new AwsS3Options
        {
            BucketName = "prod-audit-logs",
            Region = "us-east-1"
        };
        options.Compliance.OrganizationId = Environment.GetEnvironmentVariable("AUDIT_ORG_ID");
        options.Compliance.Environment = "Production";
    });
}
```

## Configuration from appsettings.json

```json
{
  "AuditLedger": {
    "Storage": {
      "Provider": "AwsS3",
      "AwsS3": {
        "BucketName": "audit-logs",
        "Region": "us-east-1"
      }
    },
    "Compliance": {
      "OrganizationId": "your-company-id",
      "Environment": "Production"
    }
  }
}
```

```csharp
services.AddAuditLedger(
    builder.Configuration.GetSection("AuditLedger")
);
```

## Security Best Practices

### Credential Management

- **Never hardcode credentials** in source code
- Use environment variables or secret management services (Azure Key Vault, AWS Secrets Manager)
- Prefer IAM roles (AWS) or managed identities (Azure) over access keys
- Rotate credentials regularly

### Storage Provider Permissions

Grant only required permissions:

**AWS S3:**
- `s3:PutObject` - Write events
- `s3:GetObject` - Read events
- `s3:ListBucket` - Query events

**Azure Blob:**
- `Storage Blob Data Contributor` role (or equivalent)

## Next Steps

1. **[Deployment Overview](overview.md)** - Deployment strategies
2. **[Quick Start](../getting-started/quick-start.md)** - Get started in 5 minutes
3. **[API Reference](../api/overview.md)** - Complete API documentation
4. **[Classes & Types](../api/classes.md)** - Configuration class reference

For detailed configuration class properties, see the [Classes & Types](../api/classes.md) documentation.
