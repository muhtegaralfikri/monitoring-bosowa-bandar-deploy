#!/usr/bin/env bash
set -euo pipefail

APP_DIR=/mnt/hdd/.apps/monitoring-bosowa-bandar-deploy
DB_PASS_FILE=/mnt/hdd/.apps/monitoring-bosowa-bandar-db.pass

cd "$APP_DIR"

if [ ! -f "$DB_PASS_FILE" ]; then
  openssl rand -hex 24 > "$DB_PASS_FILE"
  chmod 600 "$DB_PASS_FILE"
fi

DB_PASS=$(cat "$DB_PASS_FILE")

mysql <<SQL
CREATE DATABASE IF NOT EXISTS monitoring_bosowa_bandar CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'monitoring_bosowa_bandar'@'%' IDENTIFIED BY '${DB_PASS}';
ALTER USER 'monitoring_bosowa_bandar'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON monitoring_bosowa_bandar.* TO 'monitoring_bosowa_bandar'@'%';
FLUSH PRIVILEGES;
SQL

if [ ! -f backend.env ]; then
  cat > backend.env <<EOF
NODE_ENV=production
APP_PORT=3000
APP_TIMEZONE=Asia/Makassar
ENABLE_SWAGGER=true
ENABLE_CORS=true
CORS_ORIGINS=http://100.84.28.55:8093

DB_TYPE=mysql
DB_HOST=host.docker.internal
DB_PORT=3306
DB_USERNAME=monitoring_bosowa_bandar
DB_PASSWORD=${DB_PASS}
DB_NAME=monitoring_bosowa_bandar
DB_SYNCHRONIZE=false
DB_LOGGING=false

JWT_SECRET=$(openssl rand -hex 32)
JWT_ACCESS_TTL_SECONDS=86400
JWT_REFRESH_TTL_SECONDS=604800
SEED_DEFAULT_USERS=true
EOF
fi

docker compose -f compose.yml pull
docker compose -f compose.yml up -d

echo "Monitoring Bosowa Bandar: http://100.84.28.55:8093"
echo "Login: admin@example.com / password123"

