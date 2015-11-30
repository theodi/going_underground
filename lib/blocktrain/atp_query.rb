module Blocktrain
  class ATPQuery < Query

    attr_reader :direction

    def initialize(options={})
      @direction = options.fetch(:direction, :southbound)
      options[:signals] ||= %w[atp_worst_case_forward_location]
      super(options)
    end

    def filtered_filter
      super.tap do |f|
        f[:bool][:must] = [
          station_filter(direction, :seven_sisters),
          segments_filter(direction)
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

    def station_filter(dir, station)
      stations = {
        seven_sisters: {
          southbound: 289
        }
      }
      range = case dir
      when :northbound
        op = :gt
      when :southbound
        op = :lt
      end
      {
        range: {
          value: {
            op => stations[station][dir]
          }
        }
      }
    end

    def segments_filter(dir)
      script = case dir
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

    def puts
      results.map {|i| i['_source']}.each do |i|
        puts [i['timeStamp'].ljust(25), i['value'], i['runLengthMs']].join("\t")
      end
      nil
    end

  end
end
