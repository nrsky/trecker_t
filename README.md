# README
PLEASE READ! aboute implementation, what I've done and what not due to time restrictions
    There was limited amount of time, so many small pieces or small details left not implemented. Please read below. 
    
    I've desided to use postgres for main tables, obviously we won't create users or companies with 100K/sec. 
    Why -? Because we can verify that user/field/company exists, data is valid. 
     Also we can use this in fuuture for scaling. If we will have millions of fields - we have to pass to parameters 
     only that fields, which company works on(many_to_many companies -> fields). Or driver normally works only in one area(let's say Bavaria),
     so we can add optional attributr "area" for driver and search only fields of driver's company in this area. 
     This will reduce millions of fields to small data to process. If that will be really huge - we can also add index for fields to seach faster. 
     
     For main tables postgres - because of previoud and because of postgis extention, so  we can optimize polygon/multipoligin/etc operations. 
     
     For records that we receive every 2 second I've decided to use ElastiSearch. This is not a critical data, shouldn't have transactions, etc.
     I've decided to create benchmarks for postgres insertion/search and for ElasticSearch - please see some comments in code. 
     I didn't delete creation of Record in postgres DB(this MUST be changed). Now I create record in postgres, save and create index in ES. 
     We don't have to store this havy data in Postgres(so it it just initial version for tests etc and I didn't have enough time to clean all that)
     
     Decided to use chewy gem as a wrapper gem on ES. It was new for me, so had few issues with it: didn't implemet filter by day because chewy 
     has some issues with timestamp filtering. (Need to research). Also it soesn't work for ES5 yet, so had to use ES2 
     
     Wanted to upload data in 3 ways: 1) from file, 2) from webservice 3) seed to see big data like 100K entities
     3) fully implemented
     1) created just fields parser service, didn't implement records parser and controllers
     2) created controller endpoints(fields and records resources), didn't write microservice or web app. So POST client can be used to add data
     
     !Important  if you need any of these steps to be fully implemented - please tell me, that's not a problem (just some time)
     
     Some models/services are not fully covered with unit tests due to time. 
     And there is no feature -functional test for processed_time_by_activities endpoint(time as well) - it must be there  
     
     Also there are some small todos like add uniq validation, add custome exceptions. 
     And theris no apiary docummentation file for controllers endpoints 
     
     If you want too see any realization of this - please feel free to ask - Didn't have time to implement all. 
     
     
     Propositions for scaling: 1) add additional distinctions for fields and what fields company work on, in what area driver works to reduce queries (see previous)
     2) Research: add patch for chewy to use filters in ES 5, add field index and check graphs and multi-entity queries with ElasticSearch
     
     
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


#TODO I had to move this to migrations
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

7) # Indexes loading (Should be changed)
rake chewy:reset       there should be 10K docs under /record/_stats/docs

8) bundle exec rspec   - for tests

9) bundle exec cucumber  - for features

10) rails s Puma       #start the service
  
11) http://localhost:3000/processed_time_by_activities?driver_id=1&day=10/04/2017  #provide any existing driver_id - should be seeded in DB
cucumber feature  must be added 
example of response
{"driving":{"data":[]},"cultivating":{"data":[]},"repairing":{"data":[{"date_from":"2017-04-10T01:28:44.419Z","total_time":27.721000000000004,"date_to":"2017-04-10T01:29:12.419+00:00"},{"date_from":"2017-04-10T01:30:04.112Z","total_time":12.238,"date_to":"2017-04-10T01:30:16.112+00:00"}]}}

12) Assumptions 
  - I assume in the app that driver doesn't work if information is not provided for 30 sec. 
 
     
