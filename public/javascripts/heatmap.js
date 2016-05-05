function loadHeatmap(url) {
  var deferred = $.Deferred();

  $.getJSON(url, function(json) {
    $('#loading').addClass('hidden');
    populateMap(json)
    deferred.resolve();
  });

  return deferred.promise();
}

function populateMap(json) {
  ['northbound', 'southbound'].forEach(function(direction) {
    $('#' + direction +' li').each(function() {
      console.log(this)
      populateStation(this, json, direction)
    })
  })
}

function populateStation(el, json, direction) {
  station = $(el).attr('class').split(' ').pop()
  data = getDataforStation(json, station, direction)
  el = $(el).find(' .indicator .block')
  if (data == null) {
    el.animate({width: 0})
  } else {
    console.log(data.load)
    load = valueBetween(data.load, 0, 100)
    console.log(load)
    el.animate({width: load})
    el.css('background-color', getColour(load))
  }
}

function getDataforStation(json, station, direction) {
  var result = null
  json.forEach(function(data) {
    if (data.station == station && data.direction == direction) {
      result = data
    }
  })
  return result;
}

function nextDate(date) {
  date = Date.parse(date)
  return new Date(date + 300000).toISOString()
}

function previousDate(date) {
  date = Date.parse(date)
  return new Date(date - 300000).toISOString()
}

function cleanDate(date) {
  return date.replace('T', ' ').split('.')[0]
}

function getDataForDateTime(datetime) {
  url = '/heatmap/' + datetime
  $('#loading').removeClass('hidden');
  $('#from-date').val(cleanDate(datetime))
  loadHeatmap(url);
}

function dateFormat(date, format) {
  if(format === undefined) {
    format = "YYYY-MM-DD HH:mm:SS"
  }
  return moment.unix(date).utcOffset(0).format(format)
}

function getTicks(min, max) {
  ticks = []
  tick_labels = []
  for(var i = min; i <= max; i += 300) {
    ticks.push(i)
    tick_labels.push(dateFormat(i, 'HH:mm'))
  }
  return {
    "ticks": ticks,
    "tick_labels": tick_labels
  }
}

function valueBetween(v, min, max) {
  return (Math.min(max, Math.max(min, v)))
}
