require File.join(File.dirname(__FILE__), 'lib/sir_handel/app.rb')

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core/rake_task'
  require 'cucumber/rake/task'
  require 'coveralls/rake/task'

  RSpec::Core::RakeTask.new(:spec)
  Cucumber::Rake::Task.new
  Coveralls::RakeTask.new

  task :default => [:spec, :cucumber, 'coveralls:push']
end
