#!/bin/bash

# Create a directory for the MySQL database
mkdir -p $(pwd)/data/mysql

# SQL commands
echo '
CREATE TABLE devices (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  device_id varchar(256) NOT NULL,
  version varchar(256) NOT NULL,
  arch varchar(128) NOT NULL,
  os varchar(128) NOT NULL,
  client_address varchar(256) NOT NULL,
  login_time TIMESTAMP,
  meta JSON,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (id),
  UNIQUE KEY device_id (device_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE node_status (
  id bigint unsigned NOT NULL AUTO_INCREMENT,
  node_id varchar(256) NOT NULL,
  device_id varchar(256) NOT NULL,
  subdomain varchar(256) DEFAULT "",
  version varchar(256) NOT NULL,
  arch varchar(128) NOT NULL,
  os varchar(128) NOT NULL,
  client_address varchar(256) NOT NULL,
  geo_coordinates varchar(256) DEFAULT "",
  location varchar(256) DEFAULT "",
  country varchar(28) DEFAULT "",  
  subdivision varchar(28) DEFAULT "", 
  city varchar(28) DEFAULT "",
  login_time TIMESTAMP,
  last_active_time TIMESTAMP,
  last_avail_time TIMESTAMP,
  run_id varchar(256) DEFAULT "",
  meta JSON,
  node_version varchar(20) DEFAULT "",
  chat_model varchar(256) DEFAULT "",
  embedding_model varchar(256) DEFAULT "",
  status varchar(24),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (id),
  UNIQUE KEY node_id (node_id),
  UNIQUE KEY subdomain (subdomain),
  INDEX idx_status (status),
  INDEX idx_login_time (login_time),
  INDEX idx_last_active_time (last_active_time),
  INDEX idx_last_avail_time (last_avail_time),
  INDEX idx_country (country),
  INDEX idx_subdivision (subdivision),
  INDEX idx_city (city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE domain_nodes (
  domain varchar(256) NOT NULL,
  node_id varchar(256) NOT NULL,
  weight bigint unsigned NOT NULL,
  UNIQUE KEY node_id (node_id),
  PRIMARY KEY (domain, node_id)
);
' > init.sql

# Function to run MySQL commands
docker network create gaia-network
docker run --rm --network gaia-network --name gaia-mysql -e MYSQL_DATABASE=gaia.domain -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_USER=gaia -e MYSQL_PASSWORD=$MYSQL_PASSWORD -v "$(pwd)/data/mysql:/var/lib/mysql" -d mysql:8
sleep 20
docker run -i --rm --network gaia-network mysql:8 mysql -hgaia-mysql -ugaia -p$MYSQL_PASSWORD -D gaia.domain < init.sql
docker stop gaia-mysql
docker network rm gaia-network

rm init.sql

echo "Database initialized in ./data/mysql"