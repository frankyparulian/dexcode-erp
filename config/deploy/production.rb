set :stage, :production

role :resque_worker, %w{deploy@erp.dexcode.com}
role :resque_scheduler, %w{deploy@erp.dexcode.com}

role :app, %w{deploy@erp.dexcode.com}
role :web, %w{deploy@erp.dexcode.com}
role :db,  %w{deploy@erp.dexcode.com}

set :workers, { "*" => 1 }

server 'erp.dexcode.com', user: 'deploy', roles: %w{web app}
