#!/bin/sh
set -e

# 1. Create directories and set permissions
mkdir -p /var/lib/postgresql/data /run/postgresql
chown -R postgres:postgres /var/lib/postgresql/data /run/postgresql

# Check if the database data directory is empty
if [ ! -s "/var/lib/postgresql/data/PG_VERSION" ]; then
    echo "First boot: Initializing database cluster..."
    su postgres -c "initdb -D /var/lib/postgresql/data"

    # Start Postgres temporarily in the background for setup
    su postgres -c "postgres -D /var/lib/postgresql/data -c listen_addresses='*'" &

    # Wait for it to be ready
    until su postgres -c "pg_isready" >/dev/null 2>&1; do
      echo "Waiting for database to start..."
      sleep 1
    done

    # Create user and database (Only happens once!)
    echo "Creating user and database..."
    su postgres -c "psql --command \"CREATE USER \$POSTGRES_USER WITH PASSWORD '\$POSTGRES_PASSWORD';\""
    su postgres -c "psql --command \"CREATE DATABASE \$POSTGRES_DB OWNER \$POSTGRES_USER;\""
    
    # Shut down the background setup process safely
    su postgres -c "pg_ctl stop -D /var/lib/postgresql/data"
    echo "Initialization complete."
else
    echo "Database already initialized. Skipping setup."
fi

# 2. EXEC into Postgres as the main foreground process
exec su postgres -c "postgres -D /var/lib/postgresql/data"