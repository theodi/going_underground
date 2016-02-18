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

function getDataForDateTime(datetime) {
  url = '/heatmap/' + datetime
  $('#stations').addClass('hidden');
  $('#loading').removeClass('hidden');
  $('.indicator').remove();
  loadHeatmap(url);
}

function initButtons(datetime) {
  $('#previous').attr('disabled', true);
  $('#next').attr('data-date', nextDate(datetime));
}

function wouldBeInTheFuture(date, edge) {
  return Date.parse(date) >= Date.parse(edge)
}

function wouldBeInThePast(date, edge) {
  return Date.parse(date) <= Date.parse(edge)
}

function directionButton(date, min, max) {
  if (wouldBeInThePast(date, min)) {
    $('#previous').attr('disabled', true);
  } else {
    $('#previous').attr('disabled', false);
    $('#previous').attr('data-date', previousDate(date));
  }

  if (wouldBeInTheFuture(date, max)) {
    $('#next').attr('disabled', true);
  } else {
    $('#next').attr('disabled', false);
    $('#next').attr('data-date', nextDate(date));
  }
  getDataForDateTime(date)
}
