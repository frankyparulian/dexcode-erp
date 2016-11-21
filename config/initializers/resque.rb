require 'resque'
require 'resque-scheduler'
require 'resque/scheduler'
require 'resque/scheduler/server'
Resque.redis = 'localhost:6379'
Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
