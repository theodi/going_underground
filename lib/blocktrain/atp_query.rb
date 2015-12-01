module Blocktrain
  class ATPQuery < Query

    ATP_WORST_CASE_FORWARD_LOCATION = %w[2E5485AW]

    attr_reader :station, :direction

    def initialize(options={})
      @station = options.fetch(:station, :seven_sisters)
      @direction = options.fetch(:direction, :southbound)
      options[:memory_addresses] ||= ATP_WORST_CASE_FORWARD_LOCATION
      super(options)
    end

    def filtered_filter
      super.tap do |f|
        f[:bool][:must] = [
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

    def station_filter
      stations = {
        seven_sisters: {
          southbound: 289
        }
      }
      range = case direction
      when :northbound
        op = :gt
      when :southbound
        op = :lt
      end
      {
        range: {
          value: {
            op => stations[station][direction]
          }
        }
      }
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
