class HolidaysController < ApplicationController
  before_action :check_business_owner, except: [:index, :show]
  before_action :ensure_employee, only: [:show]
  after_action :verify_authorized

  def index
    authorize(:holidays)
    current_year = Time.now.strftime("%Y").to_i
    temp = current_company.holidays.where('extract(year from date) = ?', current_year)
    @holidays = temp.order(date: :asc)
  end

  def new
    authorize(:holidays)
    @holiday = Holiday.new
  end

  def create
    authorize(:holidays)
    @holiday= current_company.holidays.new(holiday_params)
    @holiday.save!
    redirect_to holidays_path, :notice => "Successfull Add New Holiday"
  end

  def edit
    authorize(:holidays)
    @holiday = current_company.holidays.find(params[:id])
  end

  def update
    authorize(:holidays)
    @holiday = current_company.holidays.find(params[:id])
    @holiday.update(holiday_params)
    redirect_to holidays_path, :notice => "Successfull Update Holiday"
  end

  def destroy
    authorize(:holidays)
    @holiday = current_company.holidays.find(params[:id])
    @holiday.destroy
    redirect_to holidays_path, :notice => "Successfull Delete Holiday"
  end


  private

  def holiday_params
    params.require(:holiday).permit(:name, :date, :period, :is_joint_holiday)
  end
end
