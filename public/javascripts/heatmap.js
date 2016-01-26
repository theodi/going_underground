function loadHeatmap(url) {
  var deferred = $.Deferred();

  $.getJSON(url, function(json) {
    $('#stations').removeClass('hidden');
    $('#loading').addClass('hidden');

    json.forEach(function(data) {
      count = Math.ceil(data.load / 10)
      $('#'+ data.direction +' .'+ data.station + ' a').append('<div id="indicator" class="weight-'+ count +'"></div>')
      for (var i=0; i < count; i++) {
        $('#'+ data.direction +' .'+ data.station +' #indicator').append('<span class="block" style="background-color:'+ colour(data.load) +'"></span>');
      }
    })
    deferred.resolve();
  });

  return deferred.promise();
}
