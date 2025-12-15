import { Injectable } from '@nestjs/common';
import { ConfigService as NestConfigService } from '@nestjs/config';

@Injectable()
export class AppConfigService {
  constructor(private configService: NestConfigService) {}

  get nodeEnv(): string {
    return this.configService.get<string>('NODE_ENV', 'development');
  }

  get databaseUrl(): string {
    return this.configService.get<string>('DATABASE_URL', '');
  }

  get backendBaseUrl(): string {
    return this.configService.get<string>('BACKEND_BASE_URL', 'http://localhost:3000');
  }

  get port(): number {
    return this.configService.get<number>('PORT', 3000);
  }

  get apiPrefix(): string {
    return this.configService.get<string>('API_PREFIX', 'api');
  }

  get apiVersion(): string {
    return this.configService.get<string>('API_VERSION', 'v1');
  }

  get corsOrigin(): string {
    return this.configService.get<string>('CORS_ORIGIN', '*');
  }

  get logLevel(): string {
    return this.configService.get<string>('LOG_LEVEL', 'info');
  }

  get apiHealthEndpoint(): string {
    return this.configService.get<string>('API_HEALTH_ENDPOINT', '/health');
  }

  get isDevelopment(): boolean {
    return this.nodeEnv === 'development';
  }

  get isProduction(): boolean {
    return this.nodeEnv === 'production';
  }

  get isTest(): boolean {
    return this.nodeEnv === 'test';
  }

  get jwtSecret(): string {
    return this.configService.get<string>('JWT_SECRET', 'your-secret-key-change-in-production');
  }

  get jwtExpiresIn(): string {
    return this.configService.get<string>('JWT_EXPIRES_IN', '24h');
  }

  get smtpHost(): string {
    return this.configService.get<string>('SMTP_HOST', 'smtp.gmail.com');
  }

  get smtpPort(): number {
    return this.configService.get<number>('SMTP_PORT', 587);
  }

  get smtpUser(): string {
    return this.configService.get<string>('SMTP_USER', '');
  }

  get smtpPassword(): string {
    return this.configService.get<string>('SMTP_PASSWORD', '');
  }

  // Provider-specific from email/name configuration
  get gmailFromEmail(): string {
    return this.configService.get<string>('GMAIL_FROM_EMAIL', this.smtpUser);
  }

  get gmailFromName(): string {
    return this.configService.get<string>('GMAIL_FROM_NAME', 'Door Lock System');
  }

  get sendGridFromEmail(): string {
    return this.configService.get<string>('SENDGRID_FROM_EMAIL', 'noreply@yourdomain.com');
  }

  get sendGridFromName(): string {
    return this.configService.get<string>('SENDGRID_FROM_NAME', 'Door Lock System');
  }

  get resendFromEmail(): string {
    return this.configService.get<string>('RESEND_FROM_EMAIL', 'noreply@yourdomain.com');
  }

  get resendFromName(): string {
    return this.configService.get<string>('RESEND_FROM_NAME', 'Door Lock System');
  }

  // Unified email from email/name based on provider
  get emailFromEmail(): string {
    const provider = this.emailProvider.toLowerCase();
    switch (provider) {
      case 'sendgrid':
        return this.sendGridFromEmail;
      case 'resend':
        return this.resendFromEmail;
      case 'gmail':
      default:
        return this.gmailFromEmail;
    }
  }

  get emailFromName(): string {
    const provider = this.emailProvider.toLowerCase();
    switch (provider) {
      case 'sendgrid':
        return this.sendGridFromName;
      case 'resend':
        return this.resendFromName;
      case 'gmail':
      default:
        return this.gmailFromName;
    }
  }

  // Email Provider Configuration
  get emailProvider(): string {
    return this.configService.get<string>('EMAIL_PROVIDER', 'gmail');
  }

  get sendGridApiKey(): string {
    return this.configService.get<string>('SENDGRID_API_KEY', '');
  }

  get resendApiKey(): string {
    return this.configService.get<string>('RESEND_API_KEY', '');
  }

  // Office Hours Configuration
  get officeOpeningTime(): string {
    return this.configService.get<string>('OFFICE_OPENING_TIME', '08:00');
  }

  get officeClosingTime(): string {
    return this.configService.get<string>('OFFICE_CLOSING_TIME', '17:00');
  }

  get lateThresholdMinutes(): number {
    return this.configService.get<number>('LATE_THRESHOLD_MINUTES', 15);
  }

  get workingDays(): string {
    return this.configService.get<string>('WORKING_DAYS', '1,2,3,4,5'); // Monday=1, Sunday=0
  }

  // Checkout Time Window Configuration
  get checkoutWindowStart(): string {
    return this.configService.get<string>('CHECKOUT_WINDOW_START', '16:50'); // 4:50 PM
  }

  get checkoutWindowEnd(): string {
    return this.configService.get<string>('CHECKOUT_WINDOW_END', '17:05'); // 5:05 PM
  }
}

