function populateTrain(data, index) {
  var train = '#train-' + index
  $.each(['f', 'r'], function(i, side) {
    $.each(['a', 'b', 'c', 'd'], function(j, letter) {
      var car = 'car-' + letter;
      var value = data[1][car.toUpperCase().replace('-', '_')];

      $(train + ' #' + car + '-' + side + ' .num').text(percentage(value))
      setHeight(train + ' #' + car + '-' + side + ' .level', value)
    })
  })
}

function setHeight(el, num) {
  $(el).height(percentage(num))
  $(el).css('background-color', colour(num))
}

function percentage(num) {
  return valueBetween(Math.round(num), 0, 100) + '%'
}
