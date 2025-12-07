import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../../generated/client';

// Modify DATABASE_URL to disable SSL certificate verification for Aiven
let databaseUrl = process.env.DATABASE_URL || '';
if (!databaseUrl.includes('sslmode=')) {
  databaseUrl += (databaseUrl.includes('?') ? '&' : '?') + 'sslmode=no-verify';
}

const adapter = new PrismaPg({
  connectionString: databaseUrl,
});

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma = new PrismaClient({ adapter });

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma;
