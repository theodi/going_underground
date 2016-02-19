function loadHeatmap(url) {
  var deferred = $.Deferred();

  $.getJSON(url, function(json) {
    $('#stations').removeClass('hidden');
    $('#loading').addClass('hidden');

    json.forEach(function(data) {
      $('#'+ data.direction +' .'+ data.station + ' a').append('<div class="indicator"></div>')
      $('#'+ data.direction +' .'+ data.station +' .indicator').append('<span class="block" style="background-color:'+ getColour(data.load) +'; width: '+ data.load +'%"></span>');
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
  $('#stations').addClass('hidden');
  $('#loading').removeClass('hidden');
  $('#from-date').val(cleanDate(datetime))
  $('.indicator').remove();
  loadHeatmap(url);
}

function dateFormat(date) {
  return moment.unix(date).utcOffset(0).format("YYYY-MM-DD HH:mm:SS")
}

function getTicks(min, max) {
  ticks = []
  tick_labels = []
  for(var i = min; i <= max; i += 300) {
    ticks.push(i)
    tick_labels.push(dateFormat(i))
  }
  return {
    "ticks": ticks,
    "tick_labels": tick_labels
  }
}
