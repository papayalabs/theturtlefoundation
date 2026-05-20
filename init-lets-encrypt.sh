#!/bin/bash
# Script de inicialización de certificados Let's Encrypt
# Ejecutar UNA SOLA VEZ en el servidor antes del primer docker compose up
set -e

DOMAIN="fundacionlatortuga.com"
EMAIL=ubuntu@fundacionlatortuga.com

echo "🔧 Arrancando nginx en modo HTTP para verificar el dominio..."
docker compose up -d nginx

echo "⏳ Esperando que nginx esté listo..."
sleep 5

echo "🔐 Solicitando certificado SSL para $DOMAIN..."
docker compose run --rm certbot certonly \
  --webroot \
  --webroot-path=/var/www/certbot \
  --email "$EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$DOMAIN" \
  -d "www.$DOMAIN"

echo "🔄 Recargando nginx con SSL activo..."
docker compose exec nginx nginx -s reload

echo "✅ Certificado instalado correctamente!"
echo "🌐 Tu web está disponible en https://$DOMAIN"