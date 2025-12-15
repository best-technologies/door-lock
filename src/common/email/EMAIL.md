# Email Service Documentation

The email service uses a provider-based architecture that supports multiple email providers. You can easily switch between Gmail, SendGrid, and Resend by configuring environment variables.

## Supported Providers

- **Gmail** (SMTP via nodemailer)
- **SendGrid** (API)
- **Resend** (API)

## Configuration

Set the `EMAIL_PROVIDER` environment variable to one of: `gmail`, `sendgrid`, or `resend`.

### Gmail Configuration

```env
EMAIL_PROVIDER=gmail
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
GMAIL_FROM_EMAIL=your-email@gmail.com
GMAIL_FROM_NAME=Door Lock System
```

**Note**: For Gmail, you'll need to:
1. Enable 2-factor authentication
2. Generate an App Password (not your regular password)
3. Use the App Password in `SMTP_PASSWORD`

### SendGrid Configuration

```env
EMAIL_PROVIDER=sendgrid
SENDGRID_API_KEY=your-sendgrid-api-key
SENDGRID_FROM_EMAIL=noreply@yourdomain.com
SENDGRID_FROM_NAME=Door Lock System
```

**Getting SendGrid API Key**:
1. Sign up at [SendGrid](https://sendgrid.com/)
2. Go to Settings > API Keys
3. Create a new API key with "Mail Send" permissions
4. Copy the API key to `SENDGRID_API_KEY`

### Resend Configuration

```env
EMAIL_PROVIDER=resend
RESEND_API_KEY=your-resend-api-key
RESEND_FROM_EMAIL=noreply@yourdomain.com
RESEND_FROM_NAME=Door Lock System
```

**Getting Resend API Key**:
1. Sign up at [Resend](https://resend.com/)
2. Go to API Keys section
3. Create a new API key
4. Copy the API key to `RESEND_API_KEY`
5. Verify your domain in Resend dashboard

## Architecture

The email service uses a provider pattern:

1. **IEmailProvider Interface**: Defines the contract for all email providers
2. **Provider Implementations**: 
   - `GmailProvider`: Uses nodemailer with SMTP
   - `SendGridProvider`: Uses SendGrid API
   - `ResendProvider`: Uses Resend API
3. **EmailProviderFactory**: Creates the appropriate provider based on configuration
4. **EmailService**: High-level service that uses the selected provider

## Usage

The email service is automatically initialized when the application starts. It will:
1. Read the `EMAIL_PROVIDER` environment variable
2. Create the appropriate provider instance
3. Verify the connection (in development mode)

### Sending Emails

The email service provides two main methods:

```typescript
// Send registration email
await emailService.sendRegistrationEmail(
  email,
  firstName,
  password,
  userId
);

// Send password reset email
await emailService.sendPasswordResetEmail(
  email,
  firstName,
  verificationCode
);
```

### Verifying Connection

```typescript
const isConnected = await emailService.verifyConnection();
```

## Error Handling

All providers include comprehensive error handling and logging. If a provider fails to initialize or send an email, detailed error messages will be logged.

## Switching Providers

To switch email providers, simply:
1. Update the `EMAIL_PROVIDER` environment variable
2. Configure the required credentials for the new provider
3. Restart the application

The system will automatically use the new provider without any code changes.

## Provider Comparison

| Feature | Gmail | SendGrid | Resend |
|---------|-------|----------|--------|
| Setup Complexity | Medium | Easy | Easy |
| Reliability | Medium | High | High |
| Free Tier | Limited | 100/day | 3,000/month |
| API-based | No | Yes | Yes |
| Best For | Development/Testing | Production | Production |

## Troubleshooting

### Gmail Issues

- **"Less secure app" error**: Use App Passwords instead of regular passwords
- **Connection timeouts**: Check firewall settings and SMTP port (587 or 465)
- **Rate limiting**: Gmail has daily sending limits

### SendGrid Issues

- **API key invalid**: Verify the API key has "Mail Send" permissions
- **Domain verification**: Some features require domain verification
- **Rate limits**: Check your SendGrid plan limits

### Resend Issues

- **Domain verification**: You must verify your sending domain
- **API key**: Ensure the API key is correct and has proper permissions
- **Rate limits**: Check your Resend plan limits

## Best Practices

1. **Production**: Use SendGrid or Resend for better reliability
2. **Development**: Gmail is fine for testing
3. **Error Handling**: Always handle email sending errors gracefully
4. **Logging**: Monitor email sending logs for issues
5. **Rate Limits**: Be aware of provider rate limits

