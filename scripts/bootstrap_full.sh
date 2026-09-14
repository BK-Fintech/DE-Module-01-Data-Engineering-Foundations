#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
./scripts/bootstrap_core.sh
source .env

echo "[FULL] Creating and loading Sales Data Mart..."
docker exec -i ecommerce-postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 < sql/solutions/10_create_sales_data_mart.sql
docker exec -i ecommerce-postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v ON_ERROR_STOP=1 < sql/solutions/12_load_data_mart.sql

echo "FULL BASELINE READY (CORE + MART)."
