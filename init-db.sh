#!/bin/bash
psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE ROLE papayalabs WITH LOGIN PASSWORD 'papayalabs';" 2>/dev/null || true
psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO papayalabs;" 2>/dev/null || true