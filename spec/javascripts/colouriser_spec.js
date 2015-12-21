describe('colouriser', function() {
  describe('valueBetween', function() {
    it('returns a value between two bounds', function() {
      expect(valueBetween(99, 0, 100)).toEqual(99)
      expect(valueBetween(87, 0, 100)).toEqual(87)
    })

    it('caps at the max value', function() {
      expect(valueBetween(105, 0, 100)).toEqual(100)
    })
  })

  describe('hex', function() {
    it('returns a hex representation', function() {
      expect(hex(99)).toEqual('63')
      expect(hex(7)).toEqual('7')
      expect(hex(15)).toEqual('f')
      expect(hex(123.56)).toEqual('7b')
    })
  })

  describe('percentHex', function() {
    it('turns a percentage value into a hex value', function() {
      expect(percentHex(12)).toEqual('e1')
    })
  })

  describe('byte', function() {
    it('returns a left-padded hexbyte', function() {
      expect(byte('fe')).toEqual('fe')
      expect(byte('7')).toEqual('07')
    })
  })

  describe('colour', function() {
    it('generates a colour with the default base of red', function() {
      expect(colour('12')).toEqual('#ffe1e1')
    })

    it('generates a colour with a different base', function() {
      expect(colour('57', 'blue')).toEqual('#6e6eff')
    })
  })
})
