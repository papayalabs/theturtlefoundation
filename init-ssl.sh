#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Script de inicialización SSL - ejecutar UNA VEZ en cada servidor
# Uso: ./init-ssl.sh [email]
# Ejemplo: ./init-ssl.sh admin@fundacionlatortuga.com
# ─────────────────────────────────────────────────────────────
set -e

DOMAIN="fundacionlatortuga.com"
EMAIL=${1:-admin@fundacionlatortuga.com}

echo "🔐 Iniciando setup SSL para $DOMAIN..."

# 1. Arrancar nginx en modo HTTP
echo "🔧 Arrancando nginx en modo HTTP..."
cp nginx/nginx-http.conf nginx/nginx.conf
docker compose up -d nginx
sleep 5

# 2. Pedir certificado a Let's Encrypt
echo "📡 Solicitando certificado SSL a Let's Encrypt..."
docker run --rm \
  -v theturtlefoundation_certbot_www:/var/www/certbot \
  -v theturtlefoundation_certbot_certs:/etc/letsencrypt \
  certbot/certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email "$EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$DOMAIN" \
  -d "www.$DOMAIN"

# 3. Generar ssl-dhparams.pem
echo "🔑 Generando parámetros Diffie-Hellman..."
mkdir -p nginx/ssl
openssl dhparam -out nginx/ssl/ssl-dhparams.pem 2048

# 4. Actualizar nginx-ssl.conf para apuntar al dhparams correcto
sed -i 's|/etc/letsencrypt/ssl-dhparams.pem|/etc/nginx/ssl/ssl-dhparams.pem|g' nginx/nginx-ssl.conf

# 5. Activar nginx con SSL
echo "🔄 Activando HTTPS..."
cp nginx/nginx-ssl.conf nginx/nginx.conf
docker compose restart nginx

echo ""
echo "✅ HTTPS activado correctamente!"
echo "🌐 https://$DOMAIN"