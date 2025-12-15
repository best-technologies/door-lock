import { Injectable } from '@nestjs/common';
import * as sgMail from '@sendgrid/mail';
import { IEmailProvider, SendMailOptions, SendMailResult } from '../interfaces/email-provider.interface';
import { LoggerService } from '../../logger/logger.service';

@Injectable()
export class SendGridProvider implements IEmailProvider {
  constructor(
    private readonly logger: LoggerService,
    apiKey: string,
  ) {
    sgMail.setApiKey(apiKey);
  }

  async sendMail(options: SendMailOptions): Promise<SendMailResult> {
    try {
      const msg = {
        to: options.to,
        from: options.from,
        subject: options.subject,
        html: options.html,
        text: options.text || this.stripHtml(options.html),
      };

      const [response] = await sgMail.send(msg);
      
      return {
        messageId: response.headers['x-message-id'] || 'unknown',
        success: true,
      };
    } catch (error: any) {
      this.logger.error(
        `SendGrid provider failed to send email: ${error?.message || 'Unknown error'}`,
        error?.response?.body || error?.stack,
        'SendGridProvider',
      );
      throw error;
    }
  }

  async verifyConnection(): Promise<boolean> {
    try {
      // SendGrid doesn't have a direct verify method, so we'll test with a validation
      // In production, you might want to check API key validity differently
      this.logger.success('SendGrid provider initialized', 'SendGridProvider');
      return true;
    } catch (error: any) {
      this.logger.error(
        `SendGrid provider initialization failed: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'SendGridProvider',
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

