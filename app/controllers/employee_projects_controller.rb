# Handle request for employee_projects table
class EmployeeProjectsController < ApplicationController
  before_action :employee_and_project_list, only: [:new]

  def new
  end

  def create
    employee_project = EmployeeProject.new(employee_project_params)
    employee_project.save
    redirect_to projects_url
  end

  def destroy
    project = Project.find(params[:project_id])
    project.employees.delete(params[:id])
    redirect_to projects_url
  end

  private

  def employee_project_params
    params.require(:employee_project).permit(:project_id, :employee_id)
  end

  def employee_and_project_list
    @employee_project = EmployeeProject.new
    @projects = Project.find(params[:project_id])
    employee_projects = @projects.employees
    @employees = Employee.where.not(id: employee_projects)
  
  end
end
