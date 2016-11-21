class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    if current_user
      if current_user.business_owner?
        redirect_to employees_path
      else
        redirect_to employee_path(current_user.employee)
      end
    else
      redirect_to new_user_session_path
    end
  end
end
