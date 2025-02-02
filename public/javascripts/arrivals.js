function populateTrain(data, train) {
  $.each(['back', 'front'], function(i, half) {
    $.each(['a', 'b', 'c', 'd'], function(j, letter) {
      var car = 'car-' + letter;
      var value = data[1][half][car.toUpperCase().replace('-', '_')];

      $(train).find('#' + car + '-' + half + ' .num').text(percentage(value))
      setHeight($(train).find('#' + car + '-' + half + ' .level'), value)
    })
  })
}

function setHeight(el, num) {
  $(el).height(percentage(num))
  $(el).css('background-color', getColour(num))
}

function percentage(num) {
  return valueBetween(Math.round(num), 0, 100) + '%'
}

function valueBetween(v, min, max) {
  return (Math.min(max, Math.max(min, v)))
}
