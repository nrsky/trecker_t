# README

How to set up: 

1) Install pg:

MAC -  brew install postgresql
Linux - https://www.postgresql.org/download/linux/

install postgis (geolocation) 
brew install postgis


2) Run Postgres Server
initdb /usr/local/var/postgres - if you didn't have postgres installed before 
pg_ctl -D /usr/local/var/postgres -l logfile start


#create database
rake db:create 

Enabling PostGIS

PostGIS is an optional extension that must be enabled in each database you want to use it in before you can use it. Installing the software is just the first step. DO NOT INSTALL it in the database called postgres.

Connect to your database with psql or PgAdmin. Run the following SQL. You need only install the features you want:
execute in PG console

-- Enable PostGIS (includes raster)
CREATE EXTENSION postgis;
-- Enable Topology
CREATE EXTENSION postgis_topology;
-- Enable PostGIS Advanced 3D 
-- and other geoprocessing algorithms
-- sfcgal not available with all distributions
CREATE EXTENSION postgis_sfcgal;
-- fuzzy matching needed for Tiger
CREATE EXTENSION fuzzystrmatch;
-- rule based standardizer
CREATE EXTENSION address_standardizer;
-- example rule data set
CREATE EXTENSION address_standardizer_data_us;
-- Enable US Tiger Geocoder
CREATE EXTENSION postgis_tiger_geocoder;

#run migrations

rake db:migrate
