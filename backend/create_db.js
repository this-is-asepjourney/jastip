const { PrismaClient } = require('@prisma/client');
const { execSync } = require('child_process');
try {
  console.log("Checking DB...");
  const prisma = new PrismaClient({
    datasources: {
      db: {
        url: 'postgresql://postgres:12345@localhost:5432/postgres'
      }
    }
  });
  prisma.$executeRawUnsafe('CREATE DATABASE jastip_db')
    .then(() => {
      console.log('Database created');
      process.exit(0);
    })
    .catch(e => {
      console.error(e);
      process.exit(1);
    });
} catch(e) {
  console.error(e);
}
