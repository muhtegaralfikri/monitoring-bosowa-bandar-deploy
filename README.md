# Monitoring Bosowa Bandar Deploy

Deployment wrapper for `muhtegaralfikri/monitoring-bosowa-bandar`.

GitHub Actions builds ARM64 images. The STB only pulls and runs them.

## Images

- `ghcr.io/muhtegaralfikri/monitoring-bosowa-bandar-api:latest`
- `ghcr.io/muhtegaralfikri/monitoring-bosowa-bandar-web:latest`

## Server

```bash
git clone https://github.com/muhtegaralfikri/monitoring-bosowa-bandar-deploy.git /mnt/hdd/.apps/monitoring-bosowa-bandar-deploy
cd /mnt/hdd/.apps/monitoring-bosowa-bandar-deploy
sudo ./server/install-or-update.sh
```

Open `http://100.84.28.55:8093`.

Default login from app seeder:

- `admin@example.com` / `password123`
- `op@example.com` / `password123`


Setelah deploy di server, jangan lupa wajib:

```
cd backend
npm run db:migration:run
npm run build
pm2 restart backend-monitoring-bosowa-bandar
```

Dan frontend:

```
cd frontend
npm run build
```
