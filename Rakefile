require File.join(File.dirname(__FILE__), 'lib/sir_handel.rb')

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'
  require 'coveralls/rake/task'

  RSpec::Core::RakeTask.new(:spec)
  Cucumber::Rake::Task.new
  Coveralls::RakeTask.new

  task :default => [:spec, :cucumber, 'coveralls:push']
end

namespace :dates do
  desc 'Store cromulised dates'
  task :cromulise do
    Dotenv.load

    SirHandel::Tasks.cromulise
  end
end

namespace :store do
  desc 'Store lookups in redis'
  task :lookups do
    Dotenv.load

    SirHandel::Tasks.get_lookups
    SirHandel::Tasks.get_aliases
  end
end
