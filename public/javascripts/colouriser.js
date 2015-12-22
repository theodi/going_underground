function valueBetween(v, min, max) {
  return (Math.min(max, Math.max(min, v)))
}

function hex(value) {
  return value.toString(16).split('.')[0]
}

function percentHex(value) {
  return hex((100 - valueBetween(Math.round(value), 0, 100)) * 2.56)
}

function byte(value) {
  return ('0' + value).slice(-2)
}

function colour(value, base) {
  if(base === undefined) {
    base = 'red'
  }

  var c = byte(percentHex(value))
  values = [c, c, c]

  switch(base.toLowerCase()) {
    case 'red':
      values[0] = 'ff'
      break;

    case 'green':
      values[1] = 'ff'
      break;

    case 'blue':
      values[2] = 'ff'
      break;

  }

  return '#' + values.join('')
}
