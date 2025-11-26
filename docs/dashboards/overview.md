# Monitoring & Observability

Monitor your Audit Ledger deployment using storage provider metrics and event querying capabilities.

## Monitoring Overview

Since Audit Ledger stores events directly in your cloud storage, monitoring focuses on:

- **Storage Provider Metrics**: Monitor storage health, usage, and costs
- **Event Querying**: Query and analyze events for compliance reporting
- **Event Chain Verification**: Verify cryptographic integrity of events
- **Cost Tracking**: Monitor storage costs by organization and environment

---

## Storage Provider Monitoring

Monitor your storage backend using native cloud provider tools:

=== "AWS S3"

    **CloudWatch Metrics:**
    - Bucket size and object count
    - Request metrics (PUT/GET operations)
    - 4xx/5xx error rates
    - Data transfer costs
    - Storage class analysis

    **Enable S3 Metrics:**
    ```bash
    aws s3api put-bucket-metrics-configuration \
      --bucket audit-logs \
      --id EntireBucket \
      --metrics-configuration Status=Enabled
    ```

=== "Azure Blob Storage"

    **Azure Monitor:**
    - Storage account capacity
    - Transaction counts (PUT/GET operations)
    - Success/failure rates
    - Ingress/egress bandwidth
    - Storage tier usage

    **Enable Metrics:**
    - Metrics are enabled by default in Azure Monitor
    - View in Azure Portal → Storage Account → Metrics

---

## CloudWatch Dashboards (AWS)

Create CloudWatch dashboards to monitor S3 bucket metrics:

```hcl
resource "aws_cloudwatch_dashboard" "audit_ledger_s3" {
  dashboard_name = "audit-ledger-storage"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/S3", "BucketSizeBytes", { stat = "Average", dimensions = { BucketName = "audit-logs", StorageType = "StandardStorage" } }],
            [".", "NumberOfObjects", { stat = "Average", dimensions = { BucketName = "audit-logs", StorageType = "AllStorageTypes" } }],
            [".", "PutRequests", { stat = "Sum", dimensions = { BucketName = "audit-logs" } }],
            [".", "GetRequests", { stat = "Sum", dimensions = { BucketName = "audit-logs" } }]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Audit Ledger S3 Storage Metrics"
        }
      }
    ]
  })
}
```

---

## Querying Events for Compliance Metrics

Query events to generate compliance reports:

### SOC 2 Metrics

```csharp
// Query events for the last 30 days
var events = await _auditLedger.GetEventsAsync(
    from: DateTime.UtcNow.AddDays(-30),
    to: DateTime.UtcNow
);

// Filter SOC 2 events
var soc2Events = events.Where(e => e.Type.StartsWith("io.auditledger.soc2"));

var metrics = new
{
    TotalAuthEvents = soc2Events.Count(e => e.Type.Contains("authentication")),
    DataAccessEvents = soc2Events.Count(e => e.Type.Contains("data.accessed")),
    UserCreatedEvents = soc2Events.Count(e => e.Type.Contains("user.created"))
};
```

### HIPAA Metrics

```csharp
// Query HIPAA events
var events = await _auditLedger.GetEventsAsync(
    from: DateTime.UtcNow.AddDays(-30),
    to: DateTime.UtcNow
);

var hipaaEvents = events.Where(e => e.Type.StartsWith("io.auditledger.hipaa"));

var auditReport = new
{
    PHIAccessCount = hipaaEvents.Count(e => e.Type.Contains("phi.disclosed")),
    PatientRecordAccess = hipaaEvents.Count(e => e.Type.Contains("patient_record.accessed")),
    TotalEvents = hipaaEvents.Count()
};
```

---

## Alerting on Storage Issues

Set up alerts for storage provider issues:

### AWS S3 Alarms

```hcl
resource "aws_cloudwatch_metric_alarm" "s3_errors" {
  alarm_name          = "audit-ledger-s3-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "4xxErrors"
  namespace           = "AWS/S3"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Alert when S3 errors exceed threshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    BucketName = "audit-logs"
  }
}

resource "aws_cloudwatch_metric_alarm" "s3_bucket_size" {
  alarm_name          = "audit-ledger-bucket-size"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = "86400"  # 1 day
  statistic           = "Average"
  threshold           = "107374182400"  # 100 GB
  alarm_description   = "Alert when bucket size exceeds 100GB"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    BucketName = "audit-logs"
    StorageType = "StandardStorage"
  }
}
```

---

## Event Chain Verification

Verify the cryptographic integrity of events:

### Automated Verification Service

Run periodic verification checks:

```csharp
public class EventChainVerificationService : BackgroundService
{
    private readonly IAuditLedgerService _auditLedger;
    private readonly ILogger<EventChainVerificationService> _logger;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                // Get recent events (last hour)
                var recentEvents = await _auditLedger.GetEventsAsync(
                    from: DateTime.UtcNow.AddHours(-1),
                    to: DateTime.UtcNow,
                    cancellationToken: stoppingToken
                );

                foreach (var evt in recentEvents)
                {
                    var verification = await _auditLedger.VerifyEventAsync(
                        evt.Id,
                        stoppingToken
                    );

                    if (!verification.IsValid)
                    {
                        // Alert on integrity violation
                        _logger.LogCritical(
                            "Event chain integrity violation detected: {EventId}. Errors: {Errors}",
                            evt.Id,
                            string.Join(", ", verification.Errors)
                        );
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during event chain verification");
            }

            await Task.Delay(TimeSpan.FromMinutes(15), stoppingToken);
        }
    }
}
```

Register the service:

```csharp
services.AddHostedService<EventChainVerificationService>();
```

---

## Cost Monitoring

### AWS S3 Cost Tracking

Monitor storage costs using AWS Cost Explorer:

**Cost Allocation Tags:**
- Tag your S3 bucket with cost allocation tags:
  - `Environment` (prod, staging, dev)
  - `Application` (your app name)
  - `ComplianceFramework` (soc2, hipaa, pci)

**Cost Analysis:**
- View costs in AWS Cost Explorer filtered by tags
- Set up cost alerts for budget thresholds
- Analyze storage class usage (Standard, Glacier, etc.)

### Azure Blob Cost Tracking

Monitor storage costs in Azure:

**Cost Management:**
- Use Azure Cost Management + Billing
- Tag storage accounts with cost allocation tags
- Set up budget alerts
- Analyze storage tier usage (Hot, Cool, Archive)

### Storage Lifecycle Policies

Configure lifecycle policies to manage costs:

**AWS S3 Lifecycle:**
```hcl
resource "aws_s3_bucket_lifecycle_configuration" "audit_logs" {
  bucket = aws_s3_bucket.audit_logs.id

  rule {
    id     = "transition-to-glacier"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  rule {
    id     = "delete-old-events"
    status = "Enabled"

    expiration {
      days = 2555  # 7 years for compliance
    }
  }
}
```

**Azure Blob Lifecycle:**
- Configure lifecycle management policies in Azure Portal
- Automatically move blobs to Cool/Archive tiers
- Set retention policies for compliance requirements

---

## Next Steps

- **[Deployment Overview](../deployment/overview.md)** - Deployment strategies
- **[Configuration Guide](../deployment/configuration.md)** - Storage configuration
- **[API Reference](../api/overview.md)** - Event querying and verification methods
- **[Quick Start](../getting-started/quick-start.md)** - Get started in 5 minutes

---

Effective monitoring ensures your audit logging infrastructure remains reliable and compliant while optimizing storage costs and performance.

