class SystemSettingsController < ApplicationController
  def new
    if params[:l]
      if params[:l] == 'google'
        setting_google_api
      end
    else
      @render_page = 'form_index'
    end
  end

  def create
    save_setting_google_api
  end

  private

  def save_setting_google_api
    GoogleApi.save_data(google_params)
    path = DriveAuthentication.new(GoogleApi.first, nil, new_system_setting_path).go_to_google_auth_location(session)
    if path && path['error']
      flash[:alert] = path['error_description']
      redirect_to new_system_setting_path
    else
      flash[:notice] = "Successfull save data"
      redirect_to path || new_system_setting_path(l: 'google');
    end
  end

  def setting_google_api
    google = GoogleApi.first
    @google =  if google then google else GoogleApi.new end
    @render_page = 'form_google'
  end
  def google_params
    params.require(:google_api).permit(:redirect_uri, :client_id, :client_secret)
  end
end
