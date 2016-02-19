describe('heatmap', function() {
  describe('loadHeatmap', function() {

    beforeEach(function(done) {
      $.fx.off = true
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

    it('hides the loading indicator', function() {
      expect($('#loading')).toHaveClass('hidden');
    });

    it('makes the block the correct width and colour', function() {
      element = $('#northbound .tottenham_hale .indicator .block')
      expect(element.attr('style')).toMatch(/width: 6.88/)
      expect(element.attr('style')).toMatch(/background-color: rgba\(38, 255, 0, 0./)
    });
  })

  describe('nextDate', function() {
    it('gets the next date', function() {
      expect(nextDate('2016-01-01T08:00:00Z')).toEqual('2016-01-01T08:05:00.000Z')
    })
  })

  describe('previousDate', function() {
    it('gets the previous date', function() {
      expect(previousDate('2016-01-01T08:00:00Z')).toEqual('2016-01-01T07:55:00.000Z')
    })
  })

  describe('getDataForDateTime', function() {
    beforeEach(function() {
      spyOn(jasmine.getGlobal(), 'loadHeatmap')
      loadFixtures('heatmap.html')
      getDataForDateTime('2016-01-01T08:00:00.000Z')
    })

    it('gets data for a specific datetime', function() {
      expect(loadHeatmap).toHaveBeenCalledWith('/heatmap/2016-01-01T08:00:00.000Z')
    })


    it('shows the loading indicator', function() {
      expect($('#loading')).not.toHaveClass('hidden');
    });

    it('sets the correct datetime value', function() {
      debugger
      expect($('#from-date').val()).toEqual('2016-01-01 08:00:00');
    });
  })

  describe('dateFormat', function() {
    it('formats a date correctly', function() {
      expect(dateFormat(1451635200)).toEqual('2016-01-01 08:00:00')
    })
  })

})
