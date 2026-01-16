import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { UsersModule } from './users/users.module';
import { AccessModule } from './access/access.module';
import { DevicesModule } from './devices/devices.module';
import { SyncModule } from './sync/sync.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { LoggerModule } from './common/logger/logger.module';
import { AppConfigModule } from './config/config.module';
import { DatabaseModule } from './database/database.module';
import { HealthModule } from './health/health.module';
import { IdentityModule } from './identity/identity.module';
import { AttendanceModule } from './attendance/attendance.module';
import { AdminModule } from './admin/admin.module';
import { HttpLoggerMiddleware } from './common/middleware/http-logger.middleware';

@Module({
  imports: [
    AppConfigModule,
    LoggerModule,
    DatabaseModule,
    HealthModule,
    IdentityModule,
    UsersModule,
    AccessModule,
    AttendanceModule,
    DevicesModule,
    SyncModule,
    DashboardModule,
    AdminModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(HttpLoggerMiddleware)
      .forRoutes('*'); // Apply to all routes
  }
}
