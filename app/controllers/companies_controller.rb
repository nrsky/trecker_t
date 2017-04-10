class CompaniesController < ActionController::Base

 #TODO update/delete company
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
    params.require(:company).permit(:name)
  end
end
