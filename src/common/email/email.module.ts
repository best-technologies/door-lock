import { Module } from '@nestjs/common';
import { EmailService } from './email.service';
import { AppConfigModule } from '../../config/config.module';
import { LoggerModule } from '../logger/logger.module';
import { EmailProviderFactory } from './providers/email-provider.factory';

@Module({
  imports: [AppConfigModule, LoggerModule],
  providers: [EmailProviderFactory, EmailService],
  exports: [EmailService],
})
export class EmailModule {}

