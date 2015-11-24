describe SirHandel::LinearTrend do
  describe 'basic linear trend' do
    # values and method from
    # http://classroom.synonym.com/calculate-trendline-2709.html

    let(:points) do
      [
        [1, 3],
        [2, 5],
        [3, 6.5]
      ]
    end

    subject(:trend) do
      SirHandel::LinearTrend.new(points)
    end

    it 'has a slope of 1.75' do
      expect(trend.slope).to eq 1.75
    end

    it 'has a y-intercept of 1.3' do
      expect(trend.intercept).to be_within(0.1).of(1.33)
    end

    it 'calculates start point' do
      expect(trend.start).to match_array([1, be_within(0.1).of(3.08)])
    end

    it 'calculates end point' do
      expect(trend.end).to match_array([3, be_within(0.1).of(6.58)])
    end
  end
end
