#app/initializers/omniauth.rb

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "159421133333-c3jvrudcjg1sb8g382506lu6c9e1vu0g.apps.googleusercontent.com", "5468tiL1oTWzcJ9uZwAxEA0p", {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
    redirect_uri:'http://localhost:3000/timesheet_report/google'
  }
end