import { Injectable } from '@nestjs/common';
import { Resend } from 'resend';
import { IEmailProvider, SendMailOptions, SendMailResult } from '../interfaces/email-provider.interface';
import { LoggerService } from '../../logger/logger.service';

@Injectable()
export class ResendProvider implements IEmailProvider {
  private resend: Resend;

  constructor(
    private readonly logger: LoggerService,
    apiKey: string,
  ) {
    this.resend = new Resend(apiKey);
  }

  async sendMail(options: SendMailOptions): Promise<SendMailResult> {
    try {
      const { data, error } = await this.resend.emails.send({
        from: options.from,
        to: options.to,
        subject: options.subject,
        html: options.html,
        text: options.text || this.stripHtml(options.html),
      });

      if (error) {
        throw new Error(`Resend API error: ${JSON.stringify(error)}`);
      }

      return {
        messageId: data?.id || 'unknown',
        success: true,
      };
    } catch (error: any) {
      this.logger.error(
        `Resend provider failed to send email: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'ResendProvider',
      );
      throw error;
    }
  }

  async verifyConnection(): Promise<boolean> {
    try {
      // Resend doesn't have a direct verify method, but we can check if API key is set
      if (!this.resend) {
        throw new Error('Resend client not initialized');
      }
      this.logger.success('Resend provider initialized', 'ResendProvider');
      return true;
    } catch (error: any) {
      this.logger.error(
        `Resend provider initialization failed: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'ResendProvider',
      );
      return false;
    }
  }

  /**
   * Strip HTML tags to create plain text version
   */
  private stripHtml(html: string): string {
    return html.replace(/<[^>]*>/g, '').replace(/&nbsp;/g, ' ').trim();
  }
}

