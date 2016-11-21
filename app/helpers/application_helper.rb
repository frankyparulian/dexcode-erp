module ApplicationHelper
	def google_oauth2_url
    scope = 'https://www.googleapis.com/auth/plus.login' \
	            ' https://www.googleapis.com/auth/plus.profile.emails.read' \
	            ' https://www.googleapis.com/auth/gmail.readonly' \
	            ' https://www.googleapis.com/auth/calendar.readonly' \
	            ' https://www.googleapis.com/auth/gmail.modify' \
	            ' https://www.googleapis.com/auth/gmail.labels'
  	@redirect_url = 'https://accounts.google.com/o/oauth2/auth?' \
      'response_type=code&' \
      "client_id=#{CGI.escape(GOOGLE_CONFIG[:client_id])}&" \
      "redirect_uri=#{CGI.escape(google_oauth2_callback_url)}&" \
      "scope=#{CGI.escape(scope)}&" \
      'approval_prompt=force&access_type=offline'
  end
end
