class CompaniesController < ActionController::Base

 #when delete - delete cascade RecordIndexes of this company
  def create
    begin
      company = Company.create(company_params)
      render json: company, status: :created
    rescue Exception => e
      render json: { :errors => [e.message] }, status: 422
    end
  end

  private

  def company_params
    params.permit(:name)
  end
end
