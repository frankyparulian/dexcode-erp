module TimesheetReportsHelper
	APPLICATION_NAME = 'Drive API Quickstart'
	PUBLIC_PATH = Rails.public_path
	CLIENT_SECRETS_PATH = "#{PUBLIC_PATH}/client.json"
	CREDENTIALS_PATH = File.join(Dir.home, '.credentials', "drive-quickstart.json")
	SCOPE = 'https://www.googleapis.com/auth/drive.metadata.readonly'

	def authorize
	  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

	  file_store = Google::APIClient::FileStore.new(CREDENTIALS_PATH)
	  storage = Google::APIClient::Storage.new(file_store)
	  auth = storage.authorize

	  if auth.nil? || (auth.expired? && auth.refresh_token.nil?)
	    app_info = Google::APIClient::ClientSecrets.load(CLIENT_SECRETS_PATH)
	    flow = Google::APIClient::InstalledAppFlow.new({
	      :client_id => GOOGLE_CONFIG[:client_id],
	      :client_secret => GOOGLE_CONFIG[:client_secret],
	      :scope => SCOPE})
	    auth = flow.authorize(storage)
	    # puts "Credentials saved to #{CREDENTIALS_PATH}" unless auth.nil?
	  end
	  auth
	end

end
