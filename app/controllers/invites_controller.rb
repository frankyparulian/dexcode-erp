require 'digest'

class InvitesController < ApplicationController

  def new
  end

  def create
    @employee = Employee.find(params[:invite][:employee_id])
    @user = User.invite!(email: params[:invite][:email], role: 'employee')
    @employee.update(user: @user)
    redirect_to employees_path
  end

  private

    def invite_params
      params.require(:invite).permit(:email, :employee_id)
    end
end
