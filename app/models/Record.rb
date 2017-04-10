# == Schema Information
#
# Table name: collections
#
#  id             :integer       not null, primary key
#  driver_id      :integer       not null
#  company_id      :integer       not null
#  timestamp      :timestamp     not null
#  latitude       :float         not null
#  longitude      :float         not null
#  accuracy
#  speed
#  created_at     :timestamp
#  updated_at     :timestamp

#TODO move update_index to action without saving model to Postgres Database.
#Persistence to PG was added for benchmarks and compare
#Add chewy:reset to update data

#accuracy field can be used to determine whether data precise or not and skip models with very low accuracy
class Record < ApplicationRecord
  update_index('record#record') { self }

  belongs_to :driver

  validates :driver_id, presence: true
  validates :timestamp, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
