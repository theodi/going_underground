describe('arrivals', function() {
  describe('percentage', function() {
    it('sets a correct percentage', function() {
      expect(percentage('41.4444')).toEqual('41%')
    });

    it('rounds up a percentage', function() {
      expect(percentage('41.5666')).toEqual('42%')
    });

    it('stops at 100%', function() {
      expect(percentage('102.5')).toEqual('100%')
    });
  });

  describe('setHeight', function() {
    it('sets the height correctly', function() {
      loadFixtures('set_height.html');
      setHeight($('#my-div'), '40')

      expect($('#my-div')).toHaveCss({height: "40px"})
    });
  })

  describe('populateTrain', function() {
    it('loads train data', function() {
      loadFixtures('train.html');
      data = [
        {
          number: 0,
          timeStamp: "2016-01-29T10:57:22.668Z"
        },
        {
          front: {
            CAR_A: 6.763636363636364,
            CAR_B: 2.0454545454545454,
            CAR_C: 3,
            CAR_D: 14.211538461538462
          },
          back: {
            CAR_A: 7.120689655172414,
            CAR_B: 23.24,
            CAR_C: 15.391304347826088,
            CAR_D: 17.264150943396228
          }
        }
      ]

      populateTrain(data, $('#train-0')[0])

      expect($('#car-a-front .num').text()).toEqual('7%');
      expect($('#car-b-front .num').text()).toEqual('2%');
      expect($('#car-c-front .num').text()).toEqual('3%');
      expect($('#car-d-front .num').text()).toEqual('14%');
      expect($('#car-a-back .num').text()).toEqual('7%');
      expect($('#car-b-back .num').text()).toEqual('23%');
      expect($('#car-c-back .num').text()).toEqual('15%');
      expect($('#car-d-back .num').text()).toEqual('17%');

      expect($('#car-a-front .level')[0].style.height).toEqual("7%")
      expect($('#car-b-front .level')[0].style.height).toEqual("2%")
      expect($('#car-c-front .level')[0].style.height).toEqual("3%")
      expect($('#car-d-front .level')[0].style.height).toEqual("14%")
      expect($('#car-a-back .level')[0].style.height).toEqual("7%")
      expect($('#car-b-back .level')[0].style.height).toEqual("23%")
      expect($('#car-c-back .level')[0].style.height).toEqual("15%")
      expect($('#car-d-back .level')[0].style.height).toEqual("17%")
    })
  })

  describe('valueBetween', function() {
    it('returns a value between two bounds', function() {
      expect(valueBetween(99, 0, 100)).toEqual(99)
      expect(valueBetween(87, 0, 100)).toEqual(87)
    })

    it('caps at the max value', function() {
      expect(valueBetween(105, 0, 100)).toEqual(100)
    })
  })
})
