class GoogleApisController < ApplicationController
  def index
    if(params[:code])
      google_data = GoogleApi.first
      google = DriveAuthentication.new(google_data, params[:code]).get_google_token
      google_uri = session.delete(:google_redirect_uri);
      if google['error_message']
        flash[:alert] = google['error_message']
      end
      redirect_to google_uri;
    else
      flash[:alert] = 'Your google code is empty !';
      redirect_to root_path;
    end
  end
end
