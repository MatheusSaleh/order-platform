#!/usr/bin/env sh
# Gera o arquivo .env com senhas aleatorias fortes.
# Uso: ./scripts/generate-env.sh            (cria .env se nao existir)
#      ./scripts/generate-env.sh --force    (sobrescreve)
set -eu

cd "$(dirname "$0")/.."

if [ -f .env ] && [ "${1:-}" != "--force" ]; then
  echo ".env ja existe. Use --force para sobrescrever (as senhas antigas deixam de valer)."
  exit 1
fi

secret() {
  # 24 bytes aleatorios em hexadecimal: seguro e sem caracteres que precisem de escape em URIs
  od -An -N24 -tx1 /dev/urandom | tr -d ' \n'
}

umask 077
cat > .env <<ENV
# Gerado por scripts/generate-env.sh em $(date -u +%Y-%m-%dT%H:%M:%SZ). NAO versione este arquivo.
RABBITMQ_USERNAME=orders
RABBITMQ_PASSWORD=$(secret)

MONGO_ROOT_USER=root
MONGO_ROOT_PASSWORD=$(secret)
MONGO_APP_USER=orders_app
MONGO_APP_PASSWORD=$(secret)

# Onde o front-end escuta. 127.0.0.1 = so acessivel pela propria maquina
# (use com o docker-compose.https.yml ou outro proxy com TLS na frente).
PUBLIC_BIND=127.0.0.1
PUBLIC_PORT=3000

# Dominio para HTTPS automatico (docker-compose.https.yml)
DOMAIN=

# Simulador da demo
SIMULATION_ENABLED=true
WORKER_PROCESSING_DELAY_MS=1200
WORKER_FAILURE_RATE=0.0
ENV

echo ".env criado com senhas aleatorias (permissao 600)."
