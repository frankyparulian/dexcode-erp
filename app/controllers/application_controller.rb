class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: "dexcode", password: "dexcoder" if Rails.env.production?

  include NgApiHandler
  include TimeDisplayHelper
  include Pundit

  before_action :authenticate_user!, except: [:me]
  before_action :ensure_company_exists!
  # before_action :doorkeeper_authorize!, only: :me

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do |e|
    message = 'You are not authorized to perform this action.'
    respond_to do |format|
      format.html { redirect_to(request.referrer || root_path, alert: message) }
      format.json { api_error(message) }
      # format.js   { render_js_error(message) }
    end
  end

  def api_success(data = {})
    render json: data
  end

  def api_error(error, status = 400)
    if error.kind_of?(ActiveRecord::Base)
      record = error
      error = record.errors.full_messages.first
    end
    render json: { error: error }, status: status
  end

  def me
    uri = URI.parse('http://localhost:3000/oauth/token')
    response = Net::HTTP.post_form(
      uri,
      code: params[:code],
      client_id: '2214df719a5df9c16656b677a941142cd8fcef20dd3669fb75d33b60123ddbc4',
      client_secret: '01f8ac9f05fcca20546fe3f391736ae5f0152c452742742efebb3606826b9bef',
      redirect_uri: 'http://localhost:3000/me',
      grant_type: 'authorization_code'
    )
    render json: response
  end

  protected

  def current_company
    return nil unless current_user

    if current_user.business_owner?
      return current_user.company
    else
      return current_user.employee.company
    end
  end

  def ensure_company_exists!
    if (!devise_controller? &&
        current_user && current_user.business_owner? &&
        current_company.nil?)
      redirect_to new_company_path
    end
  end

  def ensure_employee
    # Employee can only view its own profile
    if current_user.employee? && current_user.employee && current_user.employee.id != params[:id].to_i
      redirect_to employee_path(current_user.employee.id)
    end
  end

  def check_business_owner
    if current_user.employee?
      redirect_to root_path, notice: 'You are not the business owner.'
    end
  end

  def record_error(record)
    record.errors.full_messages.first
  end

end
