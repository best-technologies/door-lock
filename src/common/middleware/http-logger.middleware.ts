import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { LoggerService } from '../logger/logger.service';

@Injectable()
export class HttpLoggerMiddleware implements NestMiddleware {
  constructor(private readonly logger: LoggerService) {
    this.logger.setContext('HTTP');
  }

  use(req: Request, res: Response, next: NextFunction): void {
    const { method, originalUrl, ip, body, query, params } = req;
    const userAgent = req.get('user-agent') || '';
    const startTime = Date.now();

    // Log incoming request
    const requestInfo = {
      method,
      endpoint: originalUrl,
      ip,
      userAgent,
      ...(Object.keys(params).length > 0 && { params }),
      ...(Object.keys(query).length > 0 && { query }),
      ...(Object.keys(body).length > 0 && { body: this.sanitizeBody(body) }),
    };

    this.logger.http(
      `➡️  Incoming ${method} ${originalUrl}`,
      'HTTP',
    );
    
    // Log request details
    if (Object.keys(params).length > 0) {
      this.logger.debug(`   Params: ${JSON.stringify(params)}`, 'HTTP');
    }
    if (Object.keys(query).length > 0) {
      this.logger.debug(`   Query: ${JSON.stringify(query)}`, 'HTTP');
    }
    if (Object.keys(body).length > 0) {
      this.logger.debug(`   Body: ${JSON.stringify(this.sanitizeBody(body))}`, 'HTTP');
    }

    // Capture the original end function
    const originalEnd = res.end;
    const self = this;

    // Override the end function to log response
    res.end = function(chunk?: any, encoding?: any, callback?: any): any {
      // Restore original end function
      res.end = originalEnd;

      // Calculate response time
      const responseTime = Date.now() - startTime;
      const { statusCode } = res;

      // Log response
      const statusEmoji = statusCode >= 500 ? '❌' : statusCode >= 400 ? '⚠️' : '✅';
      self.logger.http(
        `${statusEmoji} ${method} ${originalUrl} - ${statusCode} - ${responseTime}ms`,
        'HTTP',
      );

      // Call the original end function
      return originalEnd.call(this, chunk, encoding, callback);
    };

    next();
  }

  /**
   * Sanitize request body to avoid logging sensitive data
   */
  private sanitizeBody(body: any): any {
    if (!body || typeof body !== 'object') {
      return body;
    }

    const sensitiveFields = [
      'password',
      'token',
      'apiKey',
      'api_key',
      'secret',
      'authorization',
      'creditCard',
      'cvv',
      'ssn',
    ];

    const sanitized = { ...body };

    for (const field of sensitiveFields) {
      if (field in sanitized) {
        sanitized[field] = '***REDACTED***';
      }
    }

    // Recursively sanitize nested objects
    for (const key in sanitized) {
      if (sanitized[key] && typeof sanitized[key] === 'object') {
        sanitized[key] = this.sanitizeBody(sanitized[key]);
      }
    }

    return sanitized;
  }
}

