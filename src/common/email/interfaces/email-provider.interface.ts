/**
 * Email Provider Interface
 * All email providers must implement this interface
 */
export interface IEmailProvider {
  /**
   * Send an email
   * @param options Email options
   * @returns Promise with message ID or result
   */
  sendMail(options: SendMailOptions): Promise<SendMailResult>;

  /**
   * Verify the email provider connection
   * @returns Promise<boolean> true if connection is valid
   */
  verifyConnection(): Promise<boolean>;
}

export interface SendMailOptions {
  from: string;
  to: string;
  subject: string;
  html: string;
  text?: string;
}

export interface SendMailResult {
  messageId: string;
  success: boolean;
}

export enum EmailProviderType {
  GMAIL = 'gmail',
  SENDGRID = 'sendgrid',
  RESEND = 'resend',
}

