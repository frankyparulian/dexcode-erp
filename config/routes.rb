Rails.application.routes.draw do
  require 'resque/scheduler/server'

  use_doorkeeper

  devise_for :users, controllers: { registrations: 'registrations' }

  # mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Resque::Server, at: '/resque'

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present?
  end

  get '/me' => 'application#me'

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => '/resque'
  end

  get '/feeds' => 'api#feeds'
  resources :invites, only: [:index, :new, :create]

  resources :interviews, only: [:index, :create, :destroy]
  post 'interviews/interviewee', to: 'interviews#get_interviewee', as: :get_interview
  put 'interviews/state', to: 'interviews#update_state', as: :state_interview

  resources :time_entries, except: :delete
  resources :employees do
    resources :employee_absences, except: :show
    collection do
      get :salaries
    end
  end
  resources :organization_structures , except: [:show]

  get "/organization_structures/getdata", to: 'organization_structures#datafilter'
  post "/organization_structures/update_parent", to: 'organization_structures#update_parent'
  resources :companies, only: [:new, :create, :edit, :update]

  resources :documents, only: [:destroy, :show, :create]
  resources :feedbacks, param: :gid, only: [:create, :show, :update] do
    get 'thanks', to: 'feedbacks#thanks'
  end
  resources :expenses
  resources :system_settings, only: [:new, :create]
  resources :google_apis, only: [:index]
  resources :holidays
  resources :projects, only: [:index, :new, :create, :destroy]
  resources :employee_projects, only: [:new, :create, :destroy]
  resources :clients

  # Timesheet report route
  get "/timesheet_report", to: 'timesheet_reports#index'
  post "/timesheet_report/get_data", to: 'timesheet_reports#get_data'

  get "/timesheet_report/chart", to: 'timesheet_reports#chart'
  post "/timesheet_report/get_chart", to: 'timesheet_reports#get_chart'

  get "/timesheet_report_google", to: 'timesheet_reports#google'
  get "/timesheet_report_google_request", to: 'timesheet_reports#google_request'

  get "/drives", to: 'drives#index'
  post "/drives/update", to: 'drives#update'
  # end

  resources :invoices do
    member do
      get :pdf
      get :download
    end
  end

  root 'home#index'
end
