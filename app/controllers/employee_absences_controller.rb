# Handle routes for Employee Absence Requests
class EmployeeAbsencesController < ApplicationController
  before_action :employee_absences, only: [:index]
  after_action :verify_authorized

  def index
    authorize(:employee_absence)
  end

  def create
    authorize(:employee_absence)
    if create_employee_absence(params)
      redirect_to employee_employee_absences_url, notice: 'Successfully Added!'
    else
      redirect_to employee_employee_absences_url, notice: 'Fail to Create Absence!'
    end
  end

  def edit
    authorize(:employee_absence)
    @employee = employee(params[:employee_id])
    @absence = absence(params[:id])
  end

  def new
    authorize(:employee_absence)
    @employee = employee(params[:employee_id])
    @absence = EmployeeAbsence.new
  end

  def update
    authorize(:employee_absence)
    if update_absence(params)
      redirect_to employee_employee_absences_url, notice: 'Successfully Updated!'
    else
      redirect_to employee_employee_absences_url, notice: 'Fail to Update Absence'
    end
  end

  def destroy
    authorize(:employee_absence)
    employee_absence = absence(params[:id])
    employee_absence.destroy
    redirect_to employee_employee_absences_url, notice: 'Successfully Deleted'
  end

  private

  def absence(id)
    EmployeeAbsence.find(id)
  end

  def employee(id)
    Employee.find(id)
  end

  def employee_absences
    employee = employee(params[:employee_id])
    @absences = employee.employee_absences.order(date: :desc)
  end

  def create_employee_absence(params)
    employee_absence = EmployeeAbsence.new
    employee_absence.date = params[:employee_absence][:date]
    employee_absence.employee_id = params[:employee_id]
    employee_absence.reason = params[:employee_absence][:reason]
    employee_absence.use_sick_days = params[:employee_absence][:use_sick_days]
    employee_absence.save
  end

  def update_absence(params)
    employee_absence = absence(params[:id])
    employee_absence.date = params[:employee_absence][:date]
    employee_absence.reason = params[:employee_absence][:reason]
    employee_absence.use_sick_days = params[:employee_absence][:use_sick_days]
    employee_absence.save
  end
end
