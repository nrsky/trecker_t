class DriversController < ActionController::Base

 #TODO update/delete driver
 #when delete - delete cascade RecordIndexes of this driver
  def create
    begin
      driver = Driver.create!(driver_params)
      render json: driver, status: :created
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  private

  def driver_params
    params.require(:driver).permit(:name)
  end
end
