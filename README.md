# README

How to set up: 

1) Install pg:

MAC -  brew install postgresql
Linux - https://www.postgresql.org/download/linux/

install postgis (geolocation) 
brew install postgis

2) install elasticsearch (any version ander 2.4 because of chewy compatibility), run port 9200 

3) Run Postgres Server
initdb /usr/local/var/postgres - if you didn't have postgres installed before 
pg_ctl -D /usr/local/var/postgres -l logfile start


#create database
rake db:create  from project directory

Enabling PostGIS

PostGIS is an optional extension that must be enabled in each database you want to use it in before you can use it. Installing the software is just the first step. DO NOT INSTALL it in the database called postgres.

Connect to your database with psql or PgAdmin. Run the following SQL. You need only install the features you want:
execute in PG console

#TODO I had to move this to migrations

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

4) bundle install

5) #run migrations

rake db:migrate

6) #seed DB, can take up to few min, depending on hardware
rake db:seed

7) # Indexes updates
rake chewy:reset       there should be 10K docs under /record/_stats/docs

8) bundle exec rspec   - for tests

9) bundle exec cucumber  - for features

10) rails s Puma       #start the service
  
11) http://localhost:3000/processed_time_by_activities?driver_id=1&day=10/04/2017  #provide any existing driver_id - should be seeded in DB
