class DriverInformationController < ActionController::Base
  protect_from_forgery with: :exception

  #
  FILE_SIZE = 5000000


  #TODO load all moked data from file
  def index

  end

  def load_fields

  end

  def load_data
    if (params[:file]) && (params[:file].size < FILE_SIZE)
      file  = params[:file]
      @parsed_data = ParserService.new.process file
    else
      raise "#{params} Params are empty or size is too big"
    end
  end
end
