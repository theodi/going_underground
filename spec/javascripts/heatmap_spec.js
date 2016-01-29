describe('heatmap', function() {
  describe('loadHeatmap', function() {

    beforeEach(function(done) {
      loadFixtures('heatmap.html')
      loadStyleFixtures('heatmap.css')
      data = getJSONFixture('heatmap.json')
      jasmine.Ajax.install();
      jasmine.Ajax.stubRequest('/heatmap.json').andReturn({
        status: 200,
        responseText: JSON.stringify(data)
      });

      loadHeatmap('/heatmap.json').done(function (result) {
        done();
      });
    })

    afterEach(function() {
      jasmine.Ajax.uninstall();
    });

    it('shows the stations', function() {
      expect($('#stations')).not.toHaveClass('hidden');
    });

    it('hides the loading indicator', function() {
      expect($('#loading')).toHaveClass('hidden');
    });

    it('makes the block the correct width and colour', function() {
      element = $('#northbound .tottenham_hale #indicator .block')

      expect(element.attr('style')).toMatch(/width: 6.884801609322975%/)
      expect(element.attr('style')).toMatch(/background-color:hsla\(111\.73823806881242,100%,50%,0.8\)/)
    });
  })
})
