ENV['RACK_ENV'] = 'cucumber'
ENV['TUBE_USERNAME'] = 'thomas'
ENV['TUBE_PASSWORD'] = 'tank_engine'

require File.join(File.dirname(__FILE__), '..', '..', 'lib/sir_handel/app.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'cucumber/api_steps'
require 'coveralls'
Coveralls.wear_merged!

Capybara.app = SirHandel::App

class SirHandelWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers

  def app
    SirHandel::App
  end
end

World do
  SirHandelWorld.new
end
