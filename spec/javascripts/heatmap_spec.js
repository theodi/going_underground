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
      element = $('#northbound .tottenham_hale .indicator .block')

      expect(element.attr('style')).toMatch(/width: 6.884801609322975%/)
      expect(element.attr('style')).toMatch(/background-color:hsla\(111\.73823806881242,100%,50%,0.8\)/)
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

    it('hides the stations', function() {
      expect($('#stations')).toHaveClass('hidden');
    });

    it('shows the loading indicator', function() {
      expect($('#loading')).not.toHaveClass('hidden');
    });

    it('sets the correct datetime value', function() {
      expect($('#from-date').val()).toEqual('2016-01-01 08:00:00');
    });


  })

  describe('initButtons', function() {
    it('initialises the buttons correctly', function() {
      setFixtures("<a href='#' class='btn btn-primary' id='previous'>Previous</a><a href='#' class='btn btn-primary' id='next'>Next</a>")

      initButtons('2016-01-01T09:00:00.000Z')

      expect($('#previous')).toHaveAttr('disabled', 'disabled')
      expect($('#next')).toHaveAttr('data-date', '2016-01-01T09:05:00.000Z')
    })
  })

  describe('directionButton', function() {
    beforeEach(function() {
      spyOn(jasmine.getGlobal(), 'getDataForDateTime')
      setFixtures("<a href='#' class='btn btn-primary' id='previous'>Previous</a><a href='#' class='btn btn-primary' id='next'>Next</a>")
    })

    it('sets the correct dates', function() {
      directionButton('2016-01-01T09:00:00.000Z', '2016-01-01T08:00:00.000Z', '2016-01-01T10:00:00.000Z')
      expect($('#previous')).toHaveAttr('data-date', '2016-01-01T08:55:00.000Z')
      expect($('#next')).toHaveAttr('data-date', '2016-01-01T09:05:00.000Z')
    })

    it('calls getDataForDateTime with the correct date', function() {
      directionButton('2016-01-01T09:00:00.000Z', '2016-01-01T08:00:00.000Z', '2016-01-01T10:00:00.000Z')
      expect(getDataForDateTime).toHaveBeenCalledWith('2016-01-01T09:00:00.000Z')
    })

    it('disables a button if beyond the edge', function() {
      directionButton('2016-01-01T09:00:00.000Z', '2016-01-01T09:00:00.000Z', '2016-01-01T10:00:00.000Z')
      expect($('#previous')).toHaveAttr('disabled', 'disabled')
      expect($('#next')).toHaveAttr('data-date', '2016-01-01T09:05:00.000Z')
    })
  })

  describe('wouldBeInTheFuture', function() {
    it('knows about past and future', function() {
      expect(wouldBeInTheFuture('2016-01-01T09:00:00.000Z', '2016-01-01T10:00:00.000Z')).toEqual(false)
      expect(wouldBeInTheFuture('2016-01-01T11:00:00.000Z', '2016-01-01T10:00:00.000Z')).toEqual(true)
      expect(wouldBeInTheFuture('2016-01-01T10:00:00.000Z', '2016-01-01T10:00:00.000Z')).toEqual(true)
    })
  })

  describe('wouldBeInThePast', function() {
    it('knows about past and future', function() {
      expect(wouldBeInThePast('2016-01-01T09:00:00.000Z', '2016-01-01T10:00:00.000Z')).toEqual(true)
      expect(wouldBeInThePast('2016-01-01T11:00:00.000Z', '2016-01-01T10:00:00.000Z')).toEqual(false)
      expect(wouldBeInThePast('2016-01-01T10:00:00.000Z', '2016-01-01T10:00:00.000Z')).toEqual(true)
    })
  })

})
