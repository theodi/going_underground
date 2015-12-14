module Blocktrain
  class ATPQuery < Query

    ATP_WORST_CASE_FORWARD_LOCATION = %w[2E5485AW]

    attr_reader :station, :direction

    def initialize(options={})
      @station = options.fetch(:station, :seven_sisters).to_s
      @direction = options.fetch(:direction, :southbound)
      options[:memory_addresses] ||= ATP_WORST_CASE_FORWARD_LOCATION
      super(options)
    end

    def filtered_filter
      super.tap do |f|
        f[:bool][:must] << [
          station_filter,
          segments_filter
        ]
      end
    end

    def body
      super.tap do |q|
        q[:sort] = sort
      end
    end

    def sort
      ['timeStamp']
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

    def segments_filter
      script = case direction
      when :northbound
        "doc['value'].value % 2 == 0"
      when :southbound
        "doc['value'].value % 2 == 1"
      end
      {
        script: {
          script: script,
          lang: 'expression'
        }
      }
    end

    def output
      results.map {|i| i['_source']}.each do |i|
        puts [i['timeStamp'].ljust(25), i['value'], i['runLengthMs']].join("\t")
      end
      nil
    end

  end
end
