class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def processed_time_by_activities
    begin
      driver = Driver.find(params[:driver_id])
      result = DriverActivityService.new.activities_for(driver.id, Date.today )
      render json: result
    rescue Exception => e
    render json: { :errors => [e.message] }, status: 422
    end
  end

  def strong_params
    params.require(:driver_id).permit(:date)
  end
end
