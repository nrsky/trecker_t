class FileUploadController < ActionController::Base

  #TODO the file will move to post after creating a view
  # Now it uploads files from fixtures directory and you have to specify the name with extention

  def upload_file
    begin
      file_params.permit!
      #this is stub
      file_path = File.join(Rails.root, 'spec', 'fixtures', params[:file_path])
      uploaded_count  = FileParserService.new.upload_fields_from(File.read(file_path), params[:file_type])
      render json: { uploaded_count:  uploaded_count}, status: 200
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  def file_params
    params.permit(:file_path, :file_type)
  end
end
