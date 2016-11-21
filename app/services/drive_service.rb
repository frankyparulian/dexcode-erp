# class for google spreadsheet
class DriveService
  # collect data chart

  def draw_spreadsheet(data)
    @time_entries = TimeEntry.data_report_time_entries(data[:project])
    draw_sheet(@time_entries, data)
  end

  def authenticate
    drive_data = GoogleApi.first
    if drive_data
      auth = authentication_google(drive_data)
      if !drive_data.access_token.present?
        if !params[:code]
          redirect = auth.authorization_uri.to_s
          redirect_to redirect
        else
          get_google_token(params[:code], drive_data)
          redirect_to '/drives'
        end
      else
        # Creates a session.
        @session = GoogleDrive.login_with_oauth(drive_data.access_token)
        if check_token_expire(drive_data)
          google_refresh_token(drive_data, true)
        end
      end
    end
    @session
  end

  private

  def get_google_token(code, token_data)
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    response = Net::HTTP.post_form(
      uri,
      'code' => code,
      'client_id' => token_data.client_id,
      'client_secret' => token_data.client_secret,
      'redirect_uri' => token_data.redirect_uri,
      'grant_type' => 'authorization_code'
    )
    result = JSON.parse(response.body) if response && JSON.parse(response.body)
    google_api = GoogleApi.find(token_data.id)
    return unless google_api
    google_api.update(
      access_token: result['access_token'],
      expire_in: result['expires_in'],
      id_token: result['id_token'],
      refresh_token: result['refresh_token']
    )
  end

  def authentication_google(data)
    client = Google::APIClient.new(
      application_name: 'Foqus',
      application_version: '1.0'
    )
    auth = client.authorization
    auth.client_id  = data.client_id
    auth.client_secret = data.client_secret
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
    auth.redirect_uri = data.redirect_uri
    auth
  end

  def google_refresh_token(data, redirect = true)
    uri = URI.parse('https://www.googleapis.com/oauth2/v3/token')
    response = Net::HTTP.post_form(
      uri,
      'refresh_token' => data.refresh_token,
      'client_id' => data.client_id,
      'client_secret' => data.client_secret,
      'grant_type' => 'refresh_token'
    )
    result = JSON.parse(response.body) if response && JSON.parse(response.body)
    google_api = GoogleApi.find(data.id)
    if google_api
      google_api.update(
        access_token: result['access_token'],
        expire_in: result['expires_in'],
        id_token: result['id_token']
      )
    end
    if redirect
      redirect_to '/drives'
    else
      google_api
    end
  end

  def check_token_expire(data)
    uri = URI("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#{data.access_token}")
    result = Net::HTTP.get(uri)
    result_json = JSON.parse(result) if result && JSON.parse(result)
    if result_json['error']
      true
    else
      false
    end
  end

  def draw_sheet(time_entries, data)
    google_token = GoogleApi.first
    if check_token_expire(google_token)
      google_token = google_refresh_token(google_token, false)
    end
    @session = GoogleDrive.login_with_oauth(google_token.access_token)
    work = @session.spreadsheet_by_key(data[:id]).worksheets[0]
    work[1, 1] = "Time Entries Report for : #{Date::MONTHNAMES[data[:month].to_i]} #{data[:year]}"
    x = 1
    y = 2
    work[y, x] = 'Date'
    x += 1
    @time_entries[:sheet_data].each do |sheet_data|
      work[y, x] = sheet_data
      x += 1
    end
    # Body
    y += 1
    first_date = Date.new(data[:year].to_i, data[:month].to_i, 1)
    last_date = Date.new(data[:year].to_i, data[:month].to_i, -1)
    range_date = get_array_month(first_date, last_date)
    range_date.each do |date|
      if date <= Time.now.to_i
        x = 1
        work[y, x] = Time.at(date).strftime('%Y-%m-%d')
        x += 1
        data_time = @time_entries[:time_entries]
          .select { |time_entries| time_entries.date.to_time.to_i == date }
        rows = JSON.parse data_time.to_json
        if rows.count > 0
          rows.each do |row|
            row.each do |key, value|
              if key != 'date' && key != 'id'
                work[y, x] = value.to_i
                x += 1
              end
            end
          end
        else
          time_entries[:project].each do ||
            work[y, x] = 0
            x += 1
          end
        end
        y += 1
      else
        x = 1
        work[y, x] = Time.at(date).strftime('%Y-%m-%d')
        x += 1
      end
    end
    work.save
  end

  def get_array_month(date_from, date_to)
    date_range = date_from..date_to
    date_months = date_range.map { |d| Date.new(d.year, d.month, d.day) }.uniq.map { |d| d.to_time.to_i }
    date_months
  end
end