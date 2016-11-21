class EmployeesController < ApplicationController
  before_action :check_business_owner, except: [:index, :show]
  before_action :ensure_employee, only: [:show]
  after_action :verify_authorized

  def index
    authorize(:employee)
    @employees = params[:show_all] ?
      current_company.employees : current_company.employees.active
  end

  def show
    authorize(:employee)
    @employee = Employee.find(params[:id])

    @month = params[:month].present? ? params[:month].to_i : Date.today.month.to_i
    @year = params[:year].present? ? params[:year].to_i : Date.today.year.to_i

    start_period = Date.new(@year, @month, 1)
    end_period = Date.new(@year, @month, 1) + 1.month
    @employee.computed_salary = @employee.monthly_salary(@month, @year)
    respond_to do |format|
      format.html
      format.json { render json: @employee }
    end
  end

  def new
    authorize(:employee)
    @employee = Employee.new
    employee_list = Employee.select(:id, :name).where("parent IS NOT NULL")
    @select_parent = [['No Parent', '0']]
    employee_list.collect{|i| @select_parent.push [i.name, i.id]}
  end

  def create
    authorize(:employee)
    @employee = Employee.new(employee_params)
    @employee.company = current_company
    @employee.save!
    redirect_to employees_path
  end

  def edit
    authorize(:employee)
    @employee = current_company.employees.find(params[:id])
    employee_list = Employee.select(:id, :name).where("parent IS NOT NULL AND id != #{params[:id]}")
    @select_parent = [['No Parent', '0']]
    employee_list.collect{|i| @select_parent.push [i.name, i.id]}
  end

  def update
    authorize(:employee)
    @employee = current_company.employees.find(params[:id])
    if @employee.update(employee_params)
      redirect_to employees_path, :notice => "Successfull edit employee"
    else
      redirect_to edit_employee_path, :alert => "Failed edit employee"
    end
  end

  def destroy
    authorize(:employee)
    @employee = current_company.employees.find(params[:id])
    @employee.destroy
    redirect_to employees_path, :notice => "Successfull Delete Employee"
  end

  def salaries
    authorize(:employee)
    @month = params[:month].present? ? params[:month].to_i : Date.today.month.to_i
    @year = params[:year].present? ? params[:year].to_i : Date.today.year.to_i
    @period = Date.new(@year, @month, 1)

    start_period = Date.new(@year, @month, 1)
    end_period = Date.new(@year, @month, 1) + 1.month
    @number_of_holidays = current_company.holidays.number_of_holidays(@month, @year)
    @employees = current_company.employees.active(start_period, end_period)
    @employees.each do |employee|
      employee.work_days = employee.total_work_days(@month, @year)
      employee.actual_work_days = employee.actual_total_work_days(@month, @year)
      employee.actual_paid_work_days = employee.paid_work_days(@month, @year)
      paid_absences = employee.number_of_paid_absences(@month, @year)
      employee.vacations = paid_absences + employee.number_of_joint_holidays(@month, @year)
      employee.absences = employee.number_of_absences(@month, @year) - paid_absences
      employee.computed_salary = employee.monthly_salary(@month, @year)
    end
  end

  private

    def employee_params
      params.require(:employee).permit(:name, :position, :salary,
        :start_date, :end_date, :bank_name, :bank_account_number, :bank_code,
        :bank_account_holder, :photo, :remote_photo_url, :remove_photo, :parent,
        :no_npwp, :status, :child, :gender, :date_of_birth, :review_month)
    end
end
