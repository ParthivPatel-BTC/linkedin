# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'whenever/capistrano'
# require 'capistrano/passenger'
require 'capistrano/unicorn_nginx'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

set :rvm_type, :user
set :rvm_ruby_version, '2.2.2'