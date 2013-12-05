namespace :dev do
  desc 'start application in local env'
  task :start do
    sh 'bundle exec shotgun config.ru'
  end
end

namespace :prod do
  desc 'start production'
  task :start do
    sh 'bundle exec thin -d -p 80 start'
  end

  desc 'stop production'
  task :stop do
    sh 'bundle exec thin stop'
  end

  desc 'restart production'
  task :restart do
    sh 'bundle exec thin restart'
  end
end