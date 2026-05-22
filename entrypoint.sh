#!/bin/bash
set -e

# ============================================================
#  Entrypoint — The Turtle Foundation Rails App
# ============================================================

# Eliminar server.pid previo para evitar que Rails piense que
# ya hay un servidor corriendo
rm -f /app/tmp/pids/server.pid

# ── Esperar a que MySQL esté listo ───────────────────────────
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-3306}"
DB_USERNAME="${DB_USERNAME:-turtle_user}"
DB_PASSWORD="${DB_PASSWORD:-turtle_password}"
DB_NAME="${DB_NAME:-theturtlefoundation_development}"

echo "⏳  Esperando a que MySQL esté disponible en ${DB_HOST}:${DB_PORT}..."
until mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_NAME" -e "SELECT 1" &>/dev/null; do
  echo "   MySQL no está listo todavía, reintentando en 2s..."
  sleep 2
done
echo "✅  MySQL está listo."

# ── Restaurar backup de base de datos ────────────────────────
echo "🔄  Restaurando backup de MySQL..."

mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -p"$DB_PASSWORD" "$DB_NAME" < /app/backup_mysql_2024_amazon.sql
echo "✅  Backup restaurado correctamente."

# ── Iniciar la aplicación ────────────────────────────────────
echo "🚀  Iniciando Rails..."
exec "$@"
