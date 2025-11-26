# Integrations

Audit Ledger integrates with cloud storage providers and can be monitored using standard observability tools.

## Cloud Storage Integrations

### AWS S3

**Storage Integration:**
```csharp
services.AddAuditLedger(options =>
{
    options.Storage.Provider = StorageProvider.AwsS3;
    options.Storage.AwsS3 = new AwsS3Options
    {
        BucketName = "audit-logs",
        Region = "us-east-1"
    };
    options.Compliance.OrganizationId = "your-company-id";
});
```

**IAM Authentication:**
- EC2 instance roles
- ECS task roles
- Lambda execution roles
- No credentials needed in code when using IAM roles

**Local Development:**
- Use [LocalStack](https://localstack.cloud/) for local S3 testing
- Configure endpoint: `ServiceUrl = "http://localhost:4566"`

### Azure Blob Storage

**Storage Integration:**
```csharp
services.AddAuditLedger(options =>
{
    options.Storage.Provider = StorageProvider.AzureBlob;
    options.Storage.AzureBlob = new AzureBlobOptions
    {
        ContainerName = "audit-logs",
        AccountName = "mystorageaccount"
    };
    options.Compliance.OrganizationId = "your-company-id";
});
```

**Managed Identity:**
- System-assigned identity (App Service, Functions)
- User-assigned identity
- Automatically used via `DefaultAzureCredential`

**Local Development:**
- Use [Azurite](https://github.com/Azure/Azurite) for local blob storage testing
- Configure connection string pointing to local Azurite instance

## Monitoring Your Storage

Since Audit Ledger stores events directly in your cloud storage, monitor your storage provider's native metrics:

### AWS S3 Monitoring

- **CloudWatch Metrics**: Monitor bucket size, request counts, errors
- **S3 Access Logging**: Enable access logs for audit trail analysis
- **CloudTrail**: Track bucket configuration changes

### Azure Blob Monitoring

- **Azure Monitor**: Track blob storage metrics and logs
- **Storage Analytics**: Enable logging and metrics
- **Activity Log**: Monitor storage account operations

## Querying Events

Events are stored as JSON files in your storage. Query them using:

- **AWS S3**: Use AWS CLI, SDK, or tools like Athena for SQL queries
- **Azure Blob**: Use Azure Storage Explorer, SDK, or Azure Data Lake Analytics
- **Custom Tools**: Build custom query tools using storage provider SDKs

## Terraform Integration

Automate infrastructure provisioning with Terraform modules:

- **AWS**: Terraform modules for S3 bucket setup with proper IAM policies
- **Azure**: Terraform modules for Blob Storage containers with access policies

See the [Quick Start](../getting-started/quick-start.md) for Terraform module links.

## Next Steps

1. **[Configuration Guide](configuration.md)** - Detailed configuration options
2. **[Deployment Overview](overview.md)** - Deployment strategies
3. **[Quick Start](../getting-started/quick-start.md)** - Get started with Terraform modules

Audit Ledger integrates seamlessly with your existing cloud infrastructure.
