require './app/services/file_parser_service'
require 'rails_helper'

describe FileParserService do
  let!(:file_with_fields){ File.join(Rails.root, 'spec', 'fixtures', 'fields.json') }
  let!(:file_with_records){ File.join(Rails.root, 'spec', 'fixtures', 'records.json') }

  context 'upload fields' do
    it 'should load all fields from file to DB' do
      expect { FileParserService.upload_fields_from(File.new(file_with_fields)) }.to change { Field.count }.from(0).to(3)
    end
  end

  context 'upload records' do
    it 'should load all records from file to DB' do
      expect { FileParserService.upload_fields_from(File.new(file_with_records)) }.to change { Record.count }.from(0).to(3)
    end
  end
end
