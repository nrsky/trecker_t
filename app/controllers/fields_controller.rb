class FieldsController < ActionController::Base

 #TODO create/update/delete field
  def create
    begin
      field = Field.new(field_params)
      field.shape = "POLYGON ((#{params[:shape]}))"
      field.save!
      render json: field, status: :created
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  private

  def field_params
    params.require(:field).permit(:name, :shape)
  end
end
