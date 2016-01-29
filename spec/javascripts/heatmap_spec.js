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
      expect($('#northbound .tottenham_hale #indicator .block')).toHaveCss({width: '7px'})
      expect($('#northbound .tottenham_hale #indicator .block')).toHaveCss({'background-color': 'rgba(38, 255, 0, 0.8)'})
    });
  })
})
