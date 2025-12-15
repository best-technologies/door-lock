import { Injectable, OnModuleInit } from '@nestjs/common';
import { AppConfigService } from '../../config/config.service';
import { LoggerService } from '../logger/logger.service';
import { registrationEmailTemplate } from './templates/registration.template';
import { passwordResetEmailTemplate } from './templates/password-reset.template';
import { IEmailProvider } from './interfaces/email-provider.interface';
import { EmailProviderFactory } from './providers/email-provider.factory';

@Injectable()
export class EmailService implements OnModuleInit {
  private emailProvider: IEmailProvider;

  constructor(
    private readonly configService: AppConfigService,
    private readonly logger: LoggerService,
    private readonly providerFactory: EmailProviderFactory,
  ) {}

  async onModuleInit() {
    try {
      this.emailProvider = this.providerFactory.createProvider();
      this.logger.info(
        `Email service initialized with provider: ${this.configService.emailProvider}`,
        'EmailService',
      );
      
      // Optionally verify connection on startup (can be disabled for faster startup)
      if (this.configService.isDevelopment) {
        const isConnected = await this.verifyConnection();
        if (!isConnected) {
          this.logger.warn(
            'Email provider connection verification failed. Emails may not be sent.',
            'EmailService',
          );
        }
      }
    } catch (error: any) {
      this.logger.error(
        `Failed to initialize email provider: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'EmailService',
      );
      throw error;
    }
  }

  /**
   * Send registration email with auto-generated password
   */
  async sendRegistrationEmail(
    email: string,
    firstName: string,
    password: string,
    userId: string,
  ): Promise<void> {
    try {
      this.logger.info(`Sending registration email to: ${email}`, 'EmailService');

      const html = registrationEmailTemplate({
        firstName,
        email,
        password,
        userId,
        companyName: this.configService.emailFromName,
      });

      const result = await this.emailProvider.sendMail({
        from: `"${this.configService.emailFromName}" <${this.configService.emailFromEmail}>`,
        to: email,
        subject: 'Welcome to Door Lock System - Your Account Details',
        html,
      });

      this.logger.success(
        `Registration email sent successfully to ${email}. Message ID: ${result.messageId}`,
        'EmailService',
      );
    } catch (error: any) {
      this.logger.error(
        `Failed to send registration email to ${email}: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'EmailService',
      );
      throw error;
    }
  }

  /**
   * Send password reset verification code
   */
  async sendPasswordResetEmail(
    email: string,
    firstName: string,
    verificationCode: string,
  ): Promise<void> {
    try {
      this.logger.info(`Sending password reset email to: ${email}`, 'EmailService');

      const html = passwordResetEmailTemplate({
        firstName,
        verificationCode,
        companyName: this.configService.emailFromName,
      });

      const result = await this.emailProvider.sendMail({
        from: `"${this.configService.emailFromName}" <${this.configService.emailFromEmail}>`,
        to: email,
        subject: 'Password Reset Verification Code',
        html,
      });

      this.logger.success(
        `Password reset email sent successfully to ${email}. Message ID: ${result.messageId}`,
        'EmailService',
      );
    } catch (error: any) {
      this.logger.error(
        `Failed to send password reset email to ${email}: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'EmailService',
      );
      throw error;
    }
  }

  /**
   * Verify email service connection
   */
  async verifyConnection(): Promise<boolean> {
    try {
      if (!this.emailProvider) {
        this.logger.warn('Email provider not initialized', 'EmailService');
        return false;
      }
      
      const result = await this.emailProvider.verifyConnection();
      if (result) {
        this.logger.success('Email service connection verified', 'EmailService');
      }
      return result;
    } catch (error: any) {
      this.logger.error(
        `Email service connection failed: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'EmailService',
      );
      return false;
    }
  }
}

