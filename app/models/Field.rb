# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null
#  shape                     :polygon          not null

class Field < ApplicationRecord
  validates :name, presence: true
  validates :shape, presence: true
end
