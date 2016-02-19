function loadHeatmap(url) {
  var deferred = $.Deferred();

  $.getJSON(url, function(json) {
    $('#loading').addClass('hidden');

    json.forEach(function(data) {
      $('#'+ data.direction +' .'+ data.station +' .indicator .block').animate({width: data.load + 10}).animate({width: data.load})
      $('#'+ data.direction +' .'+ data.station +' .indicator .block').css('background-color', getColour(data.load))
    })
    deferred.resolve();
  });

  return deferred.promise();
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
