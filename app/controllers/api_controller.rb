class ApiController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :authenticate_user!
  
  def feeds
    render json: Feedback.where(allow_publish: true)
  end
end
