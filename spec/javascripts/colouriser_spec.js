describe('colouriser', function() {

  describe('getColour', function() {
    it('generates actual useful colours', function() {
      expect(getColour(100)).toEqual('hsla(0,100%,50%,0.8)')
      expect(getColour(75)).toEqual('hsla(30,100%,50%,0.8)')
      expect(getColour(50)).toEqual('hsla(60,100%,50%,0.8)')
      expect(getColour(25)).toEqual('hsla(90,100%,50%,0.8)')
      expect(getColour(0)).toEqual('hsla(120,100%,50%,0.8)')
    })
  })

  describe('hue', function() {
    it('gets a hue', function() {
      expect(hue(1)).toEqual(0)
      expect(hue(0.75)).toEqual(30)
      expect(hue(0.50)).toEqual(60)
      expect(hue(0.25)).toEqual(90)
      expect(hue(0)).toEqual(120)
    })
  })

})
