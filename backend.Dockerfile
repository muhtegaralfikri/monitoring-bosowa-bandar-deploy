FROM node:22-bookworm-slim

WORKDIR /app

COPY backend/package*.json ./
RUN npm ci --no-audit --no-fund --progress=false

COPY backend/ ./
RUN npm run build

EXPOSE 3000

CMD ["sh", "-lc", "npm run db:migration:run && npm run start:prod"]

