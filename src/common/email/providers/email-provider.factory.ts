import { Injectable } from '@nestjs/common';
import { IEmailProvider, EmailProviderType } from '../interfaces/email-provider.interface';
import { GmailProvider } from './gmail.provider';
import { SendGridProvider } from './sendgrid.provider';
import { ResendProvider } from './resend.provider';
import { LoggerService } from '../../logger/logger.service';
import { AppConfigService } from '../../../config/config.service';

@Injectable()
export class EmailProviderFactory {
  constructor(
    private readonly logger: LoggerService,
    private readonly configService: AppConfigService,
  ) {}

  /**
   * Create an email provider based on configuration
   */
  createProvider(): IEmailProvider {
    const providerType = this.configService.emailProvider.toLowerCase() as EmailProviderType;

    switch (providerType) {
      case EmailProviderType.GMAIL:
        return this.createGmailProvider();
      
      case EmailProviderType.SENDGRID:
        return this.createSendGridProvider();
      
      case EmailProviderType.RESEND:
        return this.createResendProvider();
      
      default:
        this.logger.warn(
          `Unknown email provider: ${providerType}. Falling back to Gmail.`,
          'EmailProviderFactory',
        );
        return this.createGmailProvider();
    }
  }

  private createGmailProvider(): IEmailProvider {
    const smtpHost = this.configService.smtpHost;
    const smtpPort = this.configService.smtpPort;
    const smtpUser = this.configService.smtpUser;
    const smtpPassword = this.configService.smtpPassword;

    if (!smtpUser || !smtpPassword) {
      throw new Error(
        'Gmail provider requires SMTP_USER and SMTP_PASSWORD environment variables',
      );
    }

    this.logger.info('Initializing Gmail email provider', 'EmailProviderFactory');
    return new GmailProvider(
      this.logger,
      smtpHost,
      smtpPort,
      smtpUser,
      smtpPassword,
    );
  }

  private createSendGridProvider(): IEmailProvider {
    const apiKey = this.configService.sendGridApiKey;

    if (!apiKey) {
      throw new Error(
        'SendGrid provider requires SENDGRID_API_KEY environment variable',
      );
    }

    this.logger.info('Initializing SendGrid email provider', 'EmailProviderFactory');
    return new SendGridProvider(this.logger, apiKey);
  }

  private createResendProvider(): IEmailProvider {
    const apiKey = this.configService.resendApiKey;

    if (!apiKey) {
      throw new Error(
        'Resend provider requires RESEND_API_KEY environment variable',
      );
    }

    this.logger.info('Initializing Resend email provider', 'EmailProviderFactory');
    return new ResendProvider(this.logger, apiKey);
  }
}

