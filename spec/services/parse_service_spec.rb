require './app/services/parser_service'
require 'rails_helper'

describe ParserService do
  it '#find_record' do
    file_path =  File.join(Rails.root, 'spec', 'fixtures', 'fields.txt')
    file = mock_archive_upload(file_path, 'text')
    expect(ParserService.new.upload_fields_from(file)).to be_truthy
  end

  def mock_archive_upload(archive_path, type)
    return ActionDispatch::Http::UploadedFile.new(:tempfile => File.new(Rails.root + archive_path ,
                                                                        :type => type,
                                                                        :filename => File.basename(File.new(Rails.root + archive_path))))
  end
end
