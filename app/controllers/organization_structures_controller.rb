class OrganizationStructuresController < ApplicationController
  after_action :verify_authorized

  def index
    authorize(:organization_structure)
    respond_to do |format|
      format.html
      format.json do
        @employees = current_company.employees.active.roots
        respond_with(@employees)
      end
    end
  end

  def datafilter
    authorize(:organization_structure)
    # if request.xhr?
    render json: render_data
    # else
    #   redirect_to organization_structures_path
    # end
  end

  def destroy
    authorize(:organization_structure)
    Employee.find(params[:id]).update(parent: nil)
    render json: render_data
  end

  def update_parent
    authorize(:organization_structure)
    Employee.find(params[:child]).update(parent: params[:parent])
    render json: render_data
  end

  private

  def render_data
    data = {}
    data[:data] = format_data(0)
    data[:unparent] = unparent_data
    data
  end

  def format_data(id_parent)
    result = []
    employees = current_company.employees.active.where(parent: id_parent)
    if employees.count > 0
      employees.each do |employee|
        if !format_data(employee.id).nil?
          child = format_data(employee.id)
        else
          child = 0
        end
        temp_employee = {
          id: employee.id,
          name: employee.name,
          position: employee.position,
          child: child
        }
        result.push temp_employee
      end
    end
    result if result.count > 0
  end

  def unparent_data
    result = []
    employees = current_company.employees.active.where(parent: nil)
    if employees
      employees.each do |employee|
        unparent_employee = {
          id: employee.id,
          name: employee.name,
          position: employee.position
        }
        result.push unparent_employee
      end
    end
    result
  end
end
