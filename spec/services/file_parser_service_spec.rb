require './app/services/file_parser_service'
require 'rails_helper'

describe FileParserService do
  let!(:file) do
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'fields.json')
    file = File.read(file_path)
  end

  context 'upload fields' do
    it 'should load all records from file to DB' do
      expect { FileParserService.new.upload_fields_from(file) }.to change { Field.count }.from(0).to(3)
    end
  end
end
