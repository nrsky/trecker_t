# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null
#  shape                     :polygon          not null

class Field < ApplicationRecord
  validates :name, presence: true
  #TODO added first field to PG polygon, but I think it would be faster to move fields to elastic_search as well to compare two geo-coords.
  #Havn't done benchmarks for that
  validates :shape, presence: true
end
