import {
  Inject,
  Injectable,
  InternalServerErrorException,
  Logger,
  type OnApplicationShutdown,
  type OnModuleInit
} from '@nestjs/common';

import { ConfigurationService } from '@/configuration/configuration.service';

import { type ExtendedPrismaClient, PRISMA_CLIENT_TOKEN } from './prisma.factory';

@Injectable()
export class PrismaService implements OnModuleInit, OnApplicationShutdown {
  private readonly logger = new Logger(PrismaService.name);

  constructor(
    @Inject(PRISMA_CLIENT_TOKEN) public readonly client: ExtendedPrismaClient,
    private readonly configurationService: ConfigurationService
  ) {}

  // Replace MongoDB-specific dropDatabase with a PostgreSQL-compatible solution
  async dropDatabase() {
    this.logger.debug('Attempting to drop database...');
    try {
      await this.client.$queryRaw`DROP SCHEMA public CASCADE; CREATE SCHEMA public;`;
      this.logger.debug('Successfully dropped database');
    } catch (error) {
      throw new InternalServerErrorException('Failed to drop database: ' + { cause: error });
    }
  }

  // Replace MongoDB-specific dbStats with a PostgreSQL-compatible solution
  async getDbName() {
    this.logger.debug('Attempting to get database name...');
    const dbName = await this.client.$queryRaw`SELECT current_database()`;
    this.logger.debug(`Resolved database name: ${dbName}`);
    return dbName;
  }

  async onApplicationShutdown() {
    await this.client.$disconnect();
    if (this.configurationService.get('NODE_ENV') === 'test') {
      await this.dropDatabase();
    }
  }

  async onModuleInit() {
    this.logger.debug('Attempting to connect to database...');
    await this.client.$connect();
    this.logger.debug('Successfully connected to database');
  }
}
