#!/bin/sh
set -e

if [ "${RUN_MIGRATIONS:-true}" != "false" ]; then
  attempt=1
  max_attempts="${MIGRATION_RETRY_ATTEMPTS:-30}"

  until npm run migrate; do
    if [ "$attempt" -ge "$max_attempts" ]; then
      echo "Database migrations failed after $attempt attempts."
      exit 1
    fi

    attempt=$((attempt + 1))
    echo "Database is not ready or migrations failed. Retrying in 2 seconds..."
    sleep 2
  done
fi

exec "$@"
