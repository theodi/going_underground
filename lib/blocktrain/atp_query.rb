module Blocktrain
  class ATPQuery < Query

    ATP_WORST_CASE_FORWARD_LOCATION = %w[2E5485AW]

    attr_reader :station, :direction

    def initialize(options={})
      @station = options.fetch(:station, :seven_sisters).to_s
      @direction = options.fetch(:direction, :southbound)
      options[:sort] ||= 'timeStamp'
      options[:memory_addresses] ||= ATP_WORST_CASE_FORWARD_LOCATION
      super(options)
    end

    def build_query(addresses)
      "memoryAddress:#{addresses.first} AND value:#{station_filter}"
    end

    def station_filter
      case @direction
      when :northbound
        stations.to_a[stations.keys.index(@station) + 1].last['northbound']
      when :southbound
        stations.to_a[stations.keys.index(@station) - 1].last['southbound']
      end
    end

    def stations
      YAML.load_file File.join('config', 'stations.yml')
    end

  end
end
