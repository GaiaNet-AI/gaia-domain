#!/bin/bash

# Create a directory for the SQLite database
mkdir -p $(pwd)/data/sqlite

# Create a Dockerfile
cat << EOF > Dockerfile
FROM alpine:latest

RUN apk add --no-cache sqlite

CMD ["/bin/sh"]
EOF

# Build the Docker image
docker build -t sqlite3-alpine .

rm Dockerfile

# Function to run SQLite commands
run_sqlite() {
  docker run --rm -v "$(pwd)/data/sqlite:/data/sqlite" sqlite3-alpine sqlite3 /data/sqlite/gaia-domain.db "$@"
}

# SQL commands
run_sqlite "$(cat <<EOF
PRAGMA journal_mode = WAL;

CREATE TABLE devices (
  id integer PRIMARY KEY AUTOINCREMENT,
  device_id varchar UNIQUE NOT NULL,
  version varchar NOT NULL,
  arch varchar NOT NULL,
  os varchar NOT NULL,
  client_address varchar DEFAULT "",
  login_time bigint,
  meta text,
  created_at bigint DEFAULT (strftime('%s', 'now')),
  updated_at bigint DEFAULT (strftime('%s', 'now'))
);

CREATE TABLE node_status (
  id integer PRIMARY KEY AUTOINCREMENT,
  node_id varchar UNIQUE NOT NULL,
  device_id varchar NOT NULL,
  subdomain varchar UNIQUE DEFAULT "",
  version varchar NOT NULL,
  arch varchar NOT NULL,
  os varchar NOT NULL,
  client_address varchar DEFAULT "",
  geo_coordinates varchar DEFAULT "",
  location varchar DEFAULT "",
  country varchar DEFAULT "",  
  subdivision varchar DEFAULT "", 
  city varchar DEFAULT "",
  login_time bigint,
  last_active_time bigint,
  last_avail_time bigint,
  run_id varchar DEFAULT "",
  meta text,
  hardware text,
  node_version varchar DEFAULT "",
  chat_model varchar DEFAULT "",
  embedding_model varchar DEFAULT "",
  status varchar,
  created_at bigint DEFAULT (strftime('%s', 'now')),
  updated_at bigint DEFAULT (strftime('%s', 'now'))
);

CREATE INDEX idx_status ON node_status (status);
CREATE INDEX idx_login_time ON node_status (login_time);
CREATE INDEX idx_last_active_time ON node_status (last_active_time);
CREATE INDEX idx_last_avail_time ON node_status (last_avail_time);
CREATE INDEX idx_country ON node_status (country);
CREATE INDEX idx_subdivision ON node_status (subdivision);
CREATE INDEX idx_city ON node_status (city);

CREATE TABLE domain_nodes (
  domain varchar NOT NULL,
  node_id varchar UNIQUE NOT NULL,
  weight integer NOT NULL,
  PRIMARY KEY (domain, node_id)
);

EOF
)"


echo "Database initialized in ./data/sqlite/gaia-domain.db"