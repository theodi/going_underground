function loadHeatmap(url) {
  var deferred = $.Deferred();

  $.getJSON(url, function(json) {
    $('#stations').removeClass('hidden');
    $('#loading').addClass('hidden');

    json.forEach(function(data) {
      $('#'+ data.direction +' .'+ data.station + ' a').append('<div id="indicator"></div>')
      $('#'+ data.direction +' .'+ data.station +' #indicator').append('<span class="block" style="background-color:'+ getColor(data.load) +'; width: '+ data.load +'%"></span>');
    })
    deferred.resolve();
  });

  return deferred.promise();
}
