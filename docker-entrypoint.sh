#!/bin/bash
set -e
echo "⏳ Esperando a PostgreSQL..."
until PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -c '\q' 2>/dev/null; do
  echo "   esperando..."
  sleep 2
done
echo "✅ PostgreSQL listo, migrando..."
bundle exec rails db:migrate
echo "🚀 Arrancando la app..."
exec "$@"