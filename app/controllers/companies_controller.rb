class CompaniesController < ApplicationController
  skip_before_action :ensure_company_exists!, only: [:new, :create]

  layout 'devise', only: [:new]

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    @company.save!
    redirect_to employees_path
  end

  def edit

  end

  def update

  end

  protected

    def company_params
      params.require(:company).permit(:name)
    end

end
