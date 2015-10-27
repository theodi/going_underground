module Blocktrain
  class Lookups
    include Singleton

    def initialize
      @lookups = OpenStruct.new fetch_yaml 'lookups'
    end

    def lookups
      @lookups
    end

    private

    def fetch_yaml file
      YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config/%s.yml' % file)))
    end
  end
end
