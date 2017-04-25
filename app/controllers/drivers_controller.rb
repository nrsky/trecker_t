class DriversController < ActionController::Base

  def create
    begin
      driver = Driver.create(driver_params)
      render json: driver.to_json, status: :created
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  def index
    drivers = Driver.all
    render :json => {total_count: drivers.count, drivers: drivers.to_json}
  end

  private

  def driver_params
    params.permit(:name, :company_id)
  end
end
