class RecordsController < ActionController::Base

  def index
    #TODO move to another controller
    @companies = Company.all
    render :index
  end

  def upload
    begin
      file =  params[:file]
      total_count  = JsonParser.new.upload_fields_from(file)
      render json: { total_count:  total_count}, status: 200
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end


  #TODO after playing with PG, we should save just index without entity,
  #but I'd like to keep this code to show cucumber features, routes, params, etc
  def create
    begin
      if params[:json_text].present?
        logger.error(params[:json_text])
        params.merge!(JSON.parse(params[:json_text]))
      end

      record = Record.create(record_params)
      record.timestamp = timestamp
      if record.valid?
        record.save
        render json: record, status: :created
      else
        raise Exception.new(record.errors.first)
      end
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  def processed_time_by_activities
    begin
      driver = Driver.find(params[:driver_id])
      fields = Field.all.map(&:shape)
      raise Exception("Fields provided cannot be empty") if fields.empty?

      result = DriverActivityCalculation.new.activities_for(driver.id, Date.today, fields)
      render json: result
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  private

  def record_params
    params.permit(:company_id, :driver_id, :timestamp, :latitude, :longitude, :accuracy, :speed)
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
