import { Injectable } from '@nestjs/common';
import * as nodemailer from 'nodemailer';
import { IEmailProvider, SendMailOptions, SendMailResult } from '../interfaces/email-provider.interface';
import { LoggerService } from '../../logger/logger.service';

@Injectable()
export class GmailProvider implements IEmailProvider {
  private transporter: nodemailer.Transporter;

  constructor(
    private readonly logger: LoggerService,
    smtpHost: string,
    smtpPort: number,
    smtpUser: string,
    smtpPassword: string,
  ) {
    this.transporter = nodemailer.createTransport({
      host: smtpHost,
      port: smtpPort,
      secure: smtpPort === 465, // true for 465, false for other ports
      auth: {
        user: smtpUser,
        pass: smtpPassword,
      },
      // Add connection timeout and retry logic
      connectionTimeout: 10000, // 10 seconds
      greetingTimeout: 10000,
      socketTimeout: 10000,
    });
  }

  async sendMail(options: SendMailOptions): Promise<SendMailResult> {
    try {
      const mailOptions = {
        from: options.from,
        to: options.to,
        subject: options.subject,
        html: options.html,
        text: options.text,
      };

      const info = await this.transporter.sendMail(mailOptions);
      
      return {
        messageId: info.messageId || 'unknown',
        success: true,
      };
    } catch (error: any) {
      this.logger.error(
        `Gmail provider failed to send email: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'GmailProvider',
      );
      throw error;
    }
  }

  async verifyConnection(): Promise<boolean> {
    try {
      await this.transporter.verify();
      this.logger.success('Gmail provider connection verified', 'GmailProvider');
      return true;
    } catch (error: any) {
      this.logger.error(
        `Gmail provider connection failed: ${error?.message || 'Unknown error'}`,
        error?.stack,
        'GmailProvider',
      );
      return false;
    }
  }
}

