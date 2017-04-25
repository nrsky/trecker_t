class FieldsController < ActionController::Base

 #TODO /update/delete field
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
    params.permit(:name, :shape)
  end
end
