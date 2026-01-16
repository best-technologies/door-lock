# HTTP Logger Middleware

## Overview
Custom HTTP logging middleware that logs all incoming requests and outgoing responses with detailed information including endpoints, parameters, query strings, and request bodies.

## Features

### Incoming Request Logging
- ✅ HTTP Method (GET, POST, PUT, DELETE, etc.)
- ✅ Endpoint URL
- ✅ Request Parameters
- ✅ Query Strings
- ✅ Request Body
- ✅ IP Address
- ✅ User Agent

### Response Logging
- ✅ HTTP Status Code
- ✅ Response Time (in milliseconds)
- ✅ Visual status indicators:
  - ✅ Green checkmark for 2xx responses
  - ⚠️ Warning for 4xx responses
  - ❌ Error for 5xx responses

## Security

The middleware automatically sanitizes sensitive fields from request bodies before logging:
- `password`
- `token`
- `apiKey`
- `api_key`
- `secret`
- `authorization`
- `creditCard`
- `cvv`
- `ssn`

Sensitive fields are replaced with `***REDACTED***` in the logs.

## Usage

The middleware is already configured globally in `app.module.ts` and applies to all routes.

## Log Output Example

```
[2026-01-16T10:30:15.123Z] 🌐 HTTP [HTTP] ➡️  Incoming POST /api/v1/users
[2026-01-16T10:30:15.124Z] 🔍 DEBUG [HTTP]    Body: {"email":"user@example.com","name":"John Doe"}
[2026-01-16T10:30:15.234Z] 🌐 HTTP [HTTP] ✅ POST /api/v1/users - 201 - 111ms

[2026-01-16T10:30:20.456Z] 🌐 HTTP [HTTP] ➡️  Incoming GET /api/v1/users?role=admin&status=active
[2026-01-16T10:30:20.457Z] 🔍 DEBUG [HTTP]    Query: {"role":"admin","status":"active"}
[2026-01-16T10:30:20.489Z] 🌐 HTTP [HTTP] ✅ GET /api/v1/users?role=admin&status=active - 200 - 33ms
```

## Configuration

To adjust log levels or modify the middleware behavior:
1. Edit `src/common/middleware/http-logger.middleware.ts`
2. Modify the `LOG_LEVEL` environment variable to control verbosity
3. Add additional sensitive fields to the `sensitiveFields` array if needed

## Integration

The middleware integrates seamlessly with the existing Winston-based `LoggerService` and respects the application's logging configuration.

