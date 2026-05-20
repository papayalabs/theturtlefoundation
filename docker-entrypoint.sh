#!/bin/bash
set -e

echo "⏳ Esperando a PostgreSQL..."
until PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; do
  echo "   esperando..."
  sleep 2
done

echo "✅ PostgreSQL listo..."

# Comprobar si la DB está vacía (sin tablas)
TABLES=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" | xargs)

if [ "$TABLES" -eq "0" ]; then
  echo "📦 DB vacía, importando dump..."
  PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" < /app/backup_postgres_2024_amazon.dump.sql
  echo "✅ Dump importado!"
else
  echo "✅ DB ya tiene datos, aplicando migraciones..."
  bundle exec rails db:migrate
fi

echo "🚀 Arrancando la app..."
exec "$@"