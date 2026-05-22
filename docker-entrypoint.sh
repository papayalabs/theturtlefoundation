#!/bin/bash
set -e

echo "⏳ Esperando a MySQL..."
until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "SELECT 1" &>/dev/null; do
  echo "   esperando..."
  sleep 2
done

echo "✅ MySQL listo..."

# Comprobar si la DB está vacía (sin tablas)
TABLES=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -s --skip-column-names -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_NAME';" 2>/dev/null)

if [ "$TABLES" -eq "0" ]; then
  echo "📦 DB vacía, importando dump..."
  mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < /app/backup_mysql_2024_amazon.sql
  echo "✅ Dump importado!"
else
  echo "✅ DB ya tiene datos, aplicando migraciones..."
  bundle exec rails db:migrate
fi

echo "🚀 Arrancando la app..."
exec "$@"