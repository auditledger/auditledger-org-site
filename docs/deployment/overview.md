# Deployment Overview

Audit Ledger is deployed as a .NET library integrated into your application. You control all storage infrastructure using your own cloud storage providers.

## Deployment Model

### Library-Only SDK

Audit Ledger integrates directly into your .NET application:

```
Your Application → Audit Ledger SDK → Your Storage
                                    ├─ AWS S3 ✅
                                    └─ Azure Blob ✅
```

**Key Characteristics:**
- No external API calls (except to your storage)
- Cryptographic operations happen locally
- You control all data
- Free to use
- Zero vendor lock-in

### Terraform Infrastructure Automation

Automate storage infrastructure provisioning with Terraform modules:

**Best for:**
- AWS or Azure deployments
- Automated infrastructure setup
- Version-controlled configurations
- Complete data sovereignty

[View Terraform Modules →](../getting-started/quick-start.md)

## Supported Storage Providers

<div class="grid cards" markdown>

-   :material-aws:{ .lg .middle } **AWS S3**

    ---

    High availability and global access

    ```csharp
    options.Storage.Provider = StorageProvider.AwsS3;
    options.Storage.AwsS3 = new AwsS3Options
    {
        BucketName = "audit-logs",
        Region = "us-east-1"
    };
    options.Compliance.OrganizationId = "your-company-id";
    ```

-   :material-microsoft-azure:{ .lg .middle } **Azure Blob Storage**

    ---

    Microsoft ecosystem integration

    ```csharp
    options.Storage.Provider = StorageProvider.AzureBlob;
    options.Storage.AzureBlob = new AzureBlobOptions
    {
        ContainerName = "audit-logs",
        AccountName = "mystorageaccount"
    };
    options.Compliance.OrganizationId = "your-company-id";
    ```

</div>

**Coming Soon:**
- Google Cloud Storage
- EventStore

## Environment Configuration

Configure different storage buckets/containers for each environment:

=== "Development"

    ```csharp
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
    ```

=== "Production"

    ```csharp
    services.AddAuditLedger(options =>
    {
        options.Storage.Provider = StorageProvider.AwsS3;
        options.Storage.AwsS3 = new AwsS3Options
        {
            BucketName = "prod-audit-logs",
            Region = "us-east-1"
        };
        options.Compliance.OrganizationId = "your-company-id";
        options.Compliance.Environment = "Production";
    });
    ```

## Security Best Practices

### Storage Provider Authentication

- **AWS S3**: Use IAM roles (preferred) or access keys stored in environment variables
- **Azure Blob**: Use managed identities (preferred) or connection strings stored securely
- Never hardcode credentials in source code
- Rotate credentials regularly

### Access Control

- Grant only required storage permissions (`s3:PutObject`, `s3:GetObject`, `s3:ListBucket` for AWS)
- Use principle of least privilege
- Enable encryption at rest on storage buckets/containers
- Monitor access logs

## Configuration

### Basic Configuration

```csharp
services.AddAuditLedger(options =>
{
    options.Storage.Provider = StorageProvider.AwsS3;
    options.Storage.AwsS3 = new AwsS3Options
    {
        BucketName = Environment.GetEnvironmentVariable("AUDIT_BUCKET"),
        Region = Environment.GetEnvironmentVariable("AWS_REGION")
    };
    options.Compliance.OrganizationId = Environment.GetEnvironmentVariable("AUDIT_ORG_ID");
});
```

For detailed configuration options, see the [Configuration Guide](configuration.md).

## Best Practices

1. **Use Terraform**: Automate infrastructure provisioning with Terraform modules
2. **Separate Environments**: Use different storage buckets/containers for dev, staging, and production
3. **Secure Credentials**: Store credentials in environment variables or secret management services
4. **Monitor Storage**: Monitor your storage provider's metrics and costs
5. **Plan Retention**: Configure lifecycle policies on storage buckets/containers for compliance retention requirements

## Next Steps

1. **[Configuration Guide](configuration.md)** - Detailed configuration options
2. **[Integration Guide](integrations.md)** - Cloud and service integrations

Audit Ledger's flexible deployment ensures you can meet compliance requirements while maintaining control over your data.
