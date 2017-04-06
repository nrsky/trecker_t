# == Schema Information
#
# Table name: collections
#
#  id             :integer   not null, primary key
#  driver_id
#  timestamp
#  latitude
#  longitude
#  accuracy
#  speed

#TODO to think to move to ElasticSearch
class DriverRecord < ApplicationRecord
end
