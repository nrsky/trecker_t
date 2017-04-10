# == Schema Information
#
# Table name: collections
#
#  id                        :integer          not null, primary key
#  name                      :string(255)      not null
#  shape                     :polygon          not null


FactoryGirl.define do
  factory :field do
    name { Faker::Address::city }
    shape { "POLYGON ((75.15 29.53,77 29,77.6 29.5,75.15 29.53))" }
  end
end
