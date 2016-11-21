class DriveAuthentication
  attr_reader :drive_data, :code, :uri

  def initialize(drive_data, code = nil, uri = nil)
    @drive_data = drive_data
    @code = code
    @uri = uri
  end

  def go_to_google_auth_location(session)
    unless drive_data.refresh_token.present? && drive_data.access_token.present?
      session[:google_redirect_uri] = uri
      # session[:google_redirect_uri] = new_system_setting_path
      auth = authentication
      return auth.authorization_uri.to_s
    end
    by_refresh_token
    return false
  end

  def authentication
    client = Google::APIClient.new(
      application_name: 'Dexcode ERP',
      application_version: '1.0'
    )
    auth = client.authorization
    auth.client_id  = drive_data.client_id
    auth.client_secret = drive_data.client_secret
    auth.scope = [
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/drive',
      'https://www.googleapis.com/auth/drive.apps.readonly',
      'https://www.googleapis.com/auth/drive.readonly',
      'https://www.googleapis.com/auth/drive.readonly.metadata',
      'https://www.googleapis.com/auth/drive.metadata',
      'https://www.googleapis.com/auth/drive.install',
      'https://www.googleapis.com/auth/drive.appfolder',
      'https://www.googleapis.com/auth/drive.scripts',
      'https://spreadsheets.google.com/feeds/'
    ]
    auth.redirect_uri = drive_data.redirect_uri
    auth
  end

  def by_refresh_token
    uri = URI.parse('https://www.googleapis.com/oauth2/v3/token')
    response = Net::HTTP.post_form(
      uri,
      refresh_token: drive_data.refresh_token,
      client_id: drive_data.client_id,
      client_secret: drive_data.client_secret,
      grant_type: 'refresh_token'
    )
    result = JSON.parse(response.body) if response && JSON.parse(response.body)
    google_api = GoogleApi.find(drive_data.id)
    if result['error']
      google_api.update(refresh_token: nil)
      return result
    end
    if google_api
      google_api.update(
        access_token: result['access_token'],
        expire_in: result['expires_in'],
        id_token: result['id_token']
      )
    end
    google_api
  end

  def get_google_token
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    response = Net::HTTP.post_form(
      uri,
      code: code,
      client_id: drive_data.client_id,
      client_secret: drive_data.client_secret,
      redirect_uri: drive_data.redirect_uri,
      grant_type: 'authorization_code'
    )
    result = JSON.parse(response.body) if response && JSON.parse(response.body)
    google_api = GoogleApi.find(drive_data.id)
    return unless google_api
    unless result['refresh_token'].present?
      result['error_message'] = 'Please delete permission app in google to get "Refresh Token"!'
      return result
    end
    google_api.update(
      access_token: result['access_token'],
      expire_in: result['expires_in'],
      id_token: result['id_token'],
      refresh_token: result['refresh_token']
    )
    result
  end
end
