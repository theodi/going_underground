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
          timeStamp: "2015-09-23T08:29:05.443Z"
        },
        {
          CAR_A: 77.37209302325581,
          CAR_B: 66.67073170731707,
          CAR_C: 71.1917808219178,
          CAR_D: 59.160493827160494
        }
      ]

      populateTrain(data, $('#train-0')[0])

      expect($('#car-a-r .num').text()).toEqual('77%');
      expect($('#car-b-r .num').text()).toEqual('67%');
      expect($('#car-c-r .num').text()).toEqual('71%');
      expect($('#car-d-r .num').text()).toEqual('59%');
      expect($('#car-a-f .num').text()).toEqual('77%');
      expect($('#car-b-f .num').text()).toEqual('67%');
      expect($('#car-c-f .num').text()).toEqual('71%');
      expect($('#car-d-f .num').text()).toEqual('59%');

      expect($('#car-a-r .level')[0].style.height).toEqual("77%")
      expect($('#car-b-r .level')[0].style.height).toEqual("67%")
      expect($('#car-c-r .level')[0].style.height).toEqual("71%")
      expect($('#car-d-r .level')[0].style.height).toEqual("59%")
      expect($('#car-a-f .level')[0].style.height).toEqual("77%")
      expect($('#car-b-f .level')[0].style.height).toEqual("67%")
      expect($('#car-c-f .level')[0].style.height).toEqual("71%")
      expect($('#car-d-f .level')[0].style.height).toEqual("59%")
    })
  })
})
