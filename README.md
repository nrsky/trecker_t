# README 
     
How to set up: 

1) Install pg (9.6):

MAC -  brew install postgresql
Linux - https://www.postgresql.org/download/linux/

install postgis (geolocation) 
brew install postgis

2) install elasticsearch, run port 9200 (version  2.4 or earlier  because of chewy gem compatibility,
 gem is not ready for ElasticSearch 5, tried, but filtered is deprecated and requires a lot of patches)

3) Run Postgres Server & PostGIS
initdb /usr/local/var/postgres - if you didn't have postgres installed before 
pg_ctl -D /usr/local/var/postgres -l logfile start


#create database
rake db:create  from project directory

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

4) bundle install

5) #run migrations

rake db:migrate    

6) #seed DB, can take up to few min, depending on hardware
rake db:seed      #seeds for development only

8) bundle exec rspec   - for tests
9) bundle exec cucumber  - for features

10) rails s Puma       #start the service
  
11) http://localhost:3000/record/processed_time_by_activities?driver_id=1&day=10/04/2017  #provide any existing driver_id - should be seeded in DB
cucumber feature  must be added 
example of response
{"driving":{"data":[]},"cultivating":{"data":[]},"repairing":{"data":[{"date_from":"2017-04-10T01:28:44.419Z","total_time":27.721000000000004,"date_to":"2017-04-10T01:29:12.419+00:00"},{"date_from":"2017-04-10T01:30:04.112Z","total_time":12.238,"date_to":"2017-04-10T01:30:16.112+00:00"}]}}

12) Assumptions 
  - Polygon format is  (75.15 29.53,77 29,77.6 29.5,75.15 29.53), it can be changed easy to another format(multipoligon for more points) in DB. Please check you add this format polygon and it is exists in geography. 
  - I assume in the app that driver doesn't work if information is not provided for 30 sec. 
  

     
