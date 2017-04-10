require './app/services/file_parser_service'
require 'rails_helper'

describe FileParserService do
  let!(:file_with_fields) do
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'fields.json')
    File.read(file_path)
  end
  let!(:file_with_records) do
    file_path = File.join(Rails.root, 'spec', 'fixtures', 'records.json')
    File.read(file_path)
  end

  context 'upload fields' do
    it 'should load all fields from file to DB' do
      expect { FileParserService.new.upload_fields_from(file_with_fields, 'fields') }.to change { Field.count }.from(0).to(3)
    end
  end

  context 'upload records' do
    it 'should load all records from file to DB' do
      expect { FileParserService.new.upload_fields_from(file_with_records, 'records') }.to change { Record.count }.from(0).to(3)
    end
  end
end
