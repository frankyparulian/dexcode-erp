class TimesheetReportsController < ApplicationController
  include TimesheetReportsHelper
  def index
    @employee = Employee.all
    @project = Project.all
    @form_path = "/timesheet_report/get_data"
  end

  def chart
    @employee = Employee.all
    @project = Project.all
    @form_path = "/timesheet_report/get_chart"
	end

	def get_data
		if request.xhr?
			employee_ids = params[:employee]
			project_ids = params[:project]
			first_date = params[:first_date]
			last_date = params[:end_date]
			first_date = Date.parse(first_date).strftime("%Y-%m-%d")
			last_date = Date.parse(last_date).strftime("%Y-%m-%d")

			@employees = Employee.sum_hours(project_ids, first_date, last_date).where(id: employee_ids)
			render json: @employees.to_json
		else
			redirect_to timesheet_report
		end
	end

  def get_chart
    employee = params[:employee]
    project = params[:project]
    first_date = params[:first_date]
    last_date = params[:end_date]
    first_date = Date.parse(first_date).strftime('%Y-%m-%d')
    last_date = Date.parse(last_date).strftime('%Y-%m-%d')
    data = get_data_timesheet(project, employee, first_date, last_date)
    render json: data
  end

  def google_request
    employee = [1, 2, 3, 4, 5, 6, 7, 8]
    project = [1, 2]
    first_date = "2015/05/26"
    last_date = "2015/06/24"
    @chart_data = get_data_timesheet(project, employee, first_date, last_date)
    SpreedsheetTemplate.new(
      chart_data: @chart_data
    ).draw_timesheet

    @token = GoogleApi.first
    if !@token.access_token.present?
      if !params[:code]
        render html: auth_google(@token)
      else
        response = get_google_token(params[:code],@token)
        if @token
          tokens = GoogleApi.find(@token.id)
        else
          tokens = GoogleApi.new
        end
        tokens.access_token = response['access_token']
        tokens.expire_in = response['expires_in']
        tokens.id_token = response['id_token']
        tokens.refresh_token = response['refresh_token']
        tokens.save
        render html: response
      end
    else
      # refresh_token = google_refresh_token(@token)
      # google = google_upload_file(@token.access_token)
      # if(google[:error])
      render plain: "masuk"
    end
  end

  private

  

  def auth_google(data)
    scope = 'https://www.googleapis.com/auth/drive.file' \
            ' https://www.googleapis.com/auth/drive' \
            ' https://www.googleapis.com/auth/drive.apps.readonly' \
            ' https://www.googleapis.com/auth/drive.readonly' \
            ' https://www.googleapis.com/auth/drive.readonly.metadata' \
            ' https://www.googleapis.com/auth/drive.metadata'\
            ' https://www.googleapis.com/auth/drive.install'\
            ' https://www.googleapis.com/auth/drive.appfolder'\
            ' https://www.googleapis.com/auth/drive.scripts'
    @redirect_url = 'https://accounts.google.com/o/oauth2/auth?' \
        'response_type=code&' \
        "client_id=#{CGI.escape(GOOGLE_CONFIG[:client_id])}&" \
        "redirect_uri=#{data.redirect_uri}&" \
        "scope=#{CGI.escape(scope)}&" \
        'approval_prompt=force&access_type=offline'
    uri = URI(@redirect_url)
    @parse_data = Net::HTTP.get(uri).html_safe # => String
    @parse_data
  end

  def get_google_token(code, token_data)
    uri = URI.parse('https://accounts.google.com/o/oauth2/token')
    response = Net::HTTP.post_form(uri,
      'code' => code,
      'client_id' => GOOGLE_CONFIG[:client_id],
      'client_secret' => GOOGLE_CONFIG[:client_secret],
      'redirect_uri' => token_data.redirect_uri,
      'grant_type' => 'authorization_code'
    )
    JSON.parse(response.body) if response && JSON.parse(response.body)
  end

  def google_refresh_token(data)
    uri = URI.parse('https://www.googleapis.com/oauth2/v3/token')
    response = Net::HTTP.post_form(uri, 
        'refresh_token' => data.refresh_token,
        'client_id' => GOOGLE_CONFIG[:client_id],
        'client_secret' => GOOGLE_CONFIG[:client_secret],
        'grant_type' => 'refresh_token'
    )
    result = JSON.parse(response.body) if response && JSON.parse(response.body)
    tokens = GoogleApi.find(data.id)
    tokens.access_token = result['access_token']
    tokens.expire_in = result['expires_in']
    tokens.id_token = result['id_token']
    tokens.refresh_token = result['refresh_token']
    tokens.save
    tokens
  end

  def get_data_timesheet(project_ids, employee_ids, first_date, last_date)
    @time_entries = TimeEntry.timesheet_data(project_ids, employee_ids, first_date, last_date)
    TimesheetsService.new(
      chart_data: @time_entries,
      first_date: first_date,
      last_date: last_date
    ).chart
  end
  def google_upload_file(token)
    uri = URI.parse('https://www.googleapis.com/upload/drive/v2/files?uploadType=media')
    # Token used to terminate the file in the post body. Make sure it is not
    # present in the file you're uploading.
    # boundary = "AaB03x"
    file = "#{Rails.root}/tmp/download.jpg"

    # post_body = []
    # # post_body << "Authorization: Bearer #{token}"
    # post_body << "--#{boundary}rn"
    # post_body << "Content-Disposition: form-data; name='datafile'; filename='#{File.basename(file)}'rn"
    # post_body << "Content-Type: image/jpeg"

    # post_body << "rn"
    # post_body << File.read(file)
    # post_body << "rn--#{boundary}--rn"

    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # request = Net::HTTP::Post.new(uri.request_uri)
    # request.body = post_body.join
    # request["Authorization"] = "Bearer #{token}"
    # # request["Content-Type"] = "multipart/form-data, boundary=#{boundary}"
    # request["Content-Length"] = File.size(file)
    # # request["Accept-Encoding"] = "gzip,deflate,sdch"

    # response = http.request(request)
    # binding.pry
    # url = URI.parse('http://www.example.com/upload')
    File.open(file) do |xlsx|
      req = Net::HTTP::Post::Multipart.new uri.path,
        "file" => UploadIO.new(xlsx, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", File.basename(file))
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.request(req)

      end
    end
    JSON.parse(response.body) if response && JSON.parse(response.body)
    # binding.pry 
  end 
end
