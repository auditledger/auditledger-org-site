# SOC 2 Events

Framework Helper for SOC 2 Trust Service Criteria compliance events.

---

## UserAuthentication

Creates a user authentication event for SOC 2 Security (CC6.6) compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent UserAuthentication(
        string userId,
        string? sessionId = null,
        AuthenticationResult result = AuthenticationResult.Success,
        string? ipAddress = null,
        string? userAgent = null,
        string? failureReason = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `userId` | `string` | Yes | User identifier being authenticated |
    | `sessionId` | `string?` | No | Session identifier |
    | `result` | `AuthenticationResult` | No | Authentication outcome (default: Success) |
    | `ipAddress` | `string?` | No | IP address of authentication attempt |
    | `userAgent` | `string?` | No | User agent string |
    | `failureReason` | `string?` | No | Reason for authentication failure |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | SOC 2 compliant authentication event |

    **Event Details:**

    - **Event Type (Success):** `io.auditledger.soc2.security.authentication.success`
    - **Event Type (Failure):** `io.auditledger.soc2.security.authentication.failure`
    - **Trust Service Criteria:** Security
    - **Control ID:** CC6.6
    - **Risk Level:** Low (success) / Medium (failure)

=== "Example"

    **Example usage:**

    ```csharp
    var authEvent = Soc2Events.UserAuthentication(
        userId: "user123",
        sessionId: "session456",
        result: AuthenticationResult.Success,
        ipAddress: "192.168.1.1",
        userAgent: "Mozilla/5.0..."
    );

    await _auditLedger.LogEventAsync(authEvent);
    ```

---

## UserCreated

Creates a user account creation event for SOC 2 Security (CC6.6) compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent UserCreated(
        string userId,
        string actorUserId,
        string? sessionId = null,
        string? ipAddress = null,
        string? actorRole = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `userId` | `string` | Yes | ID of user being created |
    | `actorUserId` | `string` | Yes | ID of user performing the creation |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |
    | `actorRole` | `string?` | No | Role of actor (e.g., "admin") |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | SOC 2 compliant user creation event |

    **Event Details:**

    - **Event Type:** `io.auditledger.soc2.security.user.created`
    - **Trust Service Criteria:** Security
    - **Control ID:** CC6.6
    - **Risk Level:** Low

=== "Example"

    **Example usage:**

    ```csharp
    var userEvent = Soc2Events.UserCreated(
        userId: "user123",
        actorUserId: "admin",
        sessionId: "session456",
        ipAddress: "192.168.1.1",
        actorRole: "administrator"
    );

    await _auditLedger.LogEventAsync(userEvent);
    ```

---

## UserDeleted

Creates a user account deletion event for SOC 2 Security (CC6.6) compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent UserDeleted(
        string userId,
        string actorUserId,
        string? sessionId = null,
        string? ipAddress = null,
        string? actorRole = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `userId` | `string` | Yes | ID of user being deleted |
    | `actorUserId` | `string` | Yes | ID of user performing the deletion |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |
    | `actorRole` | `string?` | No | Role of actor (e.g., "admin") |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | SOC 2 compliant user deletion event |

    **Event Details:**

    - **Event Type:** `io.auditledger.soc2.security.user.deleted`
    - **Trust Service Criteria:** Security
    - **Control ID:** CC6.6
    - **Risk Level:** Medium

=== "Example"

    **Example usage:**

    ```csharp
    var deleteEvent = Soc2Events.UserDeleted(
        userId: "user123",
        actorUserId: "admin",
        sessionId: "session456",
        ipAddress: "192.168.1.1",
        actorRole: "administrator"
    );

    await _auditLedger.LogEventAsync(deleteEvent);
    ```

---

## DataAccessed

Creates a data access event for SOC 2 Security (CC6.7) compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent DataAccessed(
        string resourceId,
        string resourceType,
        string actorUserId,
        string operation,
        string? sessionId = null,
        string? ipAddress = null,
        string? actorRole = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `resourceId` | `string` | Yes | ID of resource being accessed |
    | `resourceType` | `string` | Yes | Type of resource (e.g., "Document", "Database") |
    | `actorUserId` | `string` | Yes | ID of user accessing the resource |
    | `operation` | `string` | Yes | Operation performed (e.g., "read", "write") |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |
    | `actorRole` | `string?` | No | Role of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | SOC 2 compliant data access event |

    **Event Details:**

    - **Event Type:** `io.auditledger.soc2.security.data.accessed`
    - **Trust Service Criteria:** Security
    - **Control ID:** CC6.7
    - **Risk Level:** Low

=== "Example"

    **Example usage:**

    ```csharp
    var dataEvent = Soc2Events.DataAccessed(
        resourceId: "document123",
        resourceType: "Document",
        actorUserId: "user456",
        operation: "read",
        sessionId: "session789",
        ipAddress: "192.168.1.1",
        actorRole: "analyst"
    );

    await _auditLedger.LogEventAsync(dataEvent);
    ```

---

## SystemConfigurationChanged

Creates a system configuration change event for SOC 2 Security (CC7.1) compliance.

=== "Signature"

    **Method signature:**

    ```csharp
    public static AuditEvent SystemConfigurationChanged(
        string configKey,
        string actorUserId,
        string? oldValue = null,
        string? newValue = null,
        string? sessionId = null,
        string? ipAddress = null,
        string? actorRole = null
    )
    ```

=== "Parameters"

    | Parameter | Type | Required | Description |
    |-----------|------|----------|-------------|
    | `configKey` | `string` | Yes | Configuration key being changed |
    | `actorUserId` | `string` | Yes | ID of user making the change |
    | `oldValue` | `string?` | No | Previous configuration value |
    | `newValue` | `string?` | No | New configuration value |
    | `sessionId` | `string?` | No | Session identifier |
    | `ipAddress` | `string?` | No | IP address of actor |
    | `actorRole` | `string?` | No | Role of actor |

=== "Returns"

    | Type | Description |
    |------|-------------|
    | `AuditEvent` | SOC 2 compliant configuration change event |

    **Event Details:**

    - **Event Type:** `io.auditledger.soc2.security.configuration.changed`
    - **Trust Service Criteria:** Security
    - **Control ID:** CC7.1
    - **Risk Level:** Medium
    - **Old Value:** Stored in framework data
    - **New Value:** Stored in framework data

=== "Example"

    **Example usage:**

    ```csharp
    var configEvent = Soc2Events.SystemConfigurationChanged(
        configKey: "max_login_attempts",
        actorUserId: "admin",
        oldValue: "3",
        newValue: "5",
        sessionId: "session123",
        ipAddress: "192.168.1.1",
        actorRole: "system_administrator"
    );

    await _auditLedger.LogEventAsync(configEvent);
    ```

---

## Next Steps

- **[HIPAA Events](hipaa-events.md)** - HIPAA Framework Helper reference
- **[PCI DSS Events](pcidss-events.md)** - PCI DSS Framework Helper reference
- **[API Overview](overview.md)** - Complete API reference
- **[Quick Start](../getting-started/quick-start.md)** - Get started in 5 minutes

