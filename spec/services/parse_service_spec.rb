require './app/services/parser_service'
require 'rails_helper'

describe ParserService do
  let!(:file) do
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'fields.json')
    file = File.read(file_path)
  end


  context 'upload fields' do
    it 'should load all records from file to DB' do
      expect { ParserService.new.upload_fields_from(file) }.to change { Field.count }.from(0).to(10)
    end

    #Move to model
    it 'should create a field model with id, name ad geo-shape polygon' do
      ParserService.new.upload_fields_from(file)
      field = Field.first
      expect(field.name).to be_a String
      expect(field.shape.geometry_type.type_name).to eq("Polygon")
    end
  end
end
