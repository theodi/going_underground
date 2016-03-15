module SirHandel
  class Trend
    def initialize(points, from, to)
      @points = points.map do |p|
        [p['timestamp'].to_time.to_i, p['value'].to_f]
      end
      @from, @to = from, to
    end

    def to_hash
      return {} if @points == []
      trend = LinearTrend.new(@points)
      {
        from: {
          timestamp: @from,
          value: trend.y(Time.parse(@from).to_i)
        },
        to: {
          timestamp: @to,
          value: trend.y(Time.parse(@to).to_i)
        }
      }
    end
  end

  class LinearTrend
    def initialize(points)
      @points = points
    end

    # method from
    # http://math.stackexchange.com/questions/204020/what-is-the-equation-used-to-calculate-a-linear-trendline

    def start
      at(@points[0][0])
    end

    def end
      at(@points[-1][0])
    end

    def at(x)
      [x, y(x)]
    end

    def y(x)
      slope*x + intercept
    end

    def slope
      n = @points.size
      top = n*sumxy - (sumx*sumy)
      bottom = n*sumx2 - (sumx**2)
      @slope ||= top / (bottom.nonzero? || 1)
    end

    def intercept
      n = @points.size
      top = sumy - slope*sumx
      @intercept ||= top / n
    end

    def sumx
      @sumx ||= sum {|i| i[0]}
    end

    def sumy
      @sumy ||= sum {|i| i[1]}
    end

    def sumx2
      @sumx2 ||= sum {|i| i[0] ** 2 }
    end

    def sumxy
      @sumxy ||= sum {|i| i[0] * i[1]  }
    end

    def sum(&block)
      @points.map(&block).inject(:+)
    end
  end
end
