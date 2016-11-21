require 'resque/tasks'
require 'resque/scheduler/tasks'
require 'resque/server'

namespace :resque do
  task :setup => :environment do
    ENV['QUEUE'] = '*'
    Resque::Scheduler.dynamic = true
    Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
  end
end
