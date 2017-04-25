# == Schema Information
#
#  driver_id      :integer       not null
#  company_id      :integer       not null
#  timestamp      :timestamp     not null
#  latitude       :float         not null
#  longitude      :float         not null
#  accuracy
#  speed
#  created_at     :timestamp
#  updated_at     :timestamp

#accuracy field can be used to determine whether data precise or not and skip models with very low accuracy
class Record
  include Elasticsearch::Persistence::Model
  include Elasticsearch::Model::Callbacks


  attr_accessor :json_text

  attribute :company_id, Integer,  presence: true
  attribute :driver_id, Integer,  presence: true
  attribute :timestamp, DateTime, presence: true
  attribute :latitude, Float, presence: true
  attribute :longitude, Float, presence: true
  attribute :accuracy, Float
  attribute :speed, Float

  validates :company_id, presence: true
  validates :longitude, presence: true
  validates :latitude, presence: true


  #NOTE for high load update index after bunch operations, not for each entity
  after_save do
    puts "Successfully saved: #{self}"
    Elasticsearch::Persistence.client.indices.refresh index: 'records'
  end
end
