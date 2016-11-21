class DrivesController < ApplicationController
  before_action :load_drive_data
  before_action :ensure_drive_access_token, only: [:index]
  before_action :load_drive_session
  after_action :verify_authorized

  def index
    authorize(:drive)

    @project = Project.all
  end

  def update
    authorize(:drive)

    if params[:id]
      DriveDrawSheet.new(
        @session,
        id: params[:id],
        month: params[:month],
        year: params[:year],
        project: params[:project]
      ).call
      flash[:notice] = 'Success Export Data to Google Drive!'
    else
      flash[:alert] = 'You must select at least one file!'
    end
    redirect_to '/drives'
  end

  protected

  def load_drive_data
    @drive_data = GoogleApi.first
    if @drive_data.access_token.nil?
      flash[:alert] = "Plase Set Access Token First!"
      redirect_to new_system_setting_path(l: 'google')
    end
  end

  def ensure_drive_access_token
    return if @drive_data.access_token
    if !params[:code]
      session[:google_redirect_uri] = drives_path
      auth = DriveAuthentication.new(@drive_data).authentication
      redirect = auth.authorization_uri.to_s
      redirect_to redirect
    else
      DriveAuthentication.new(@drive_data, params[:code]).get_google_token
      redirect_to '/drives'
    end
  end

  def load_drive_session
    if check_drive_token_expiration
      @session = DriveAuthentication.new(@drive_data).by_refresh_token
    else
      @session = GoogleDrive.login_with_oauth(@drive_data.access_token)
    end
  end

  def check_drive_token_expiration
    uri = URI("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#{@drive_data.access_token}")
    result = Net::HTTP.get(uri)
    result_json = JSON.parse(result) if result && JSON.parse(result)
    result_json['error'] ? true : false
  end
end
