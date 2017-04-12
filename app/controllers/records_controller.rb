class RecordsController < ActionController::Base

  def index
    render :index
  end

  def upload
    begin
      file =  params[:file]
      total_count  = FileParserService.new.upload_fields_from(file)
      render json: { total_count:  total_count}, status: 200
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end


  #TODO after playing with PG, we should save just index without entity,
  #but I'd like to keep this code to show cucumber features, routes, params, etc
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

  def processed_time_by_activities
    begin
      driver = Driver.find(params[:driver_id])
      result = DriverActivityService.new.activities_for(driver.id, Date.today )
      render json: result
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

  def upload_params
    the_params = params.require(:upload).permit(:file)
    the_params[:file] = parse_image_data(the_params[:file]) if the_params[:file]
    the_params
  end
end
