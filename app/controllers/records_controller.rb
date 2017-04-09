class RecordsController < ActionController::Base

  def create
    begin
      driver = Driver.find(params[:driver_id])
      record = Record.new(record_params)
      record.driver = driver
      record.timestamp = timestamp
      #We can assign company id as well, but I think it is redandant in this logic
      record.save!
      render json: record, status: :created
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  private

  def record_params
    params.require(:record).permit(:company_id, :driver_id, :timestamp, :latitude, :longitude, :accuracy, :speed)
  end

  def timestamp
    DateTime.parse(params[:timestamp]).to_datetime
  end
end
