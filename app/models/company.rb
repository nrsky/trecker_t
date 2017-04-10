# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null

class Company < ApplicationRecord
  has_many :drivers

  validates :name, presence: true

  #TODO add delete company should delete all drivers and RecordIndexes of this company
end
