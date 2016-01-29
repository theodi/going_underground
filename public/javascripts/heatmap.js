function loadHeatmap(url) {
  var deferred = $.Deferred();

  $.getJSON(url, function(json) {
    $('#stations').removeClass('hidden');
    $('#loading').addClass('hidden');

    json.forEach(function(data) {
      count = Math.ceil(data.load / 10)
      $('#'+ data.direction +' .'+ data.station + ' a').append('<div id="indicator" class="weight-'+ count +'"></div>')
      $('#'+ data.direction +' .'+ data.station +' #indicator').append('<span class="block" style="background-color:'+ getColor(data.load) +'; width: '+ data.load +'%"></span>');
    })
    deferred.resolve();
  });

  return deferred.promise();
}

function getColor(value){
    value = value / 100
    var hue=((1-value)*120).toString(10);
    return ["hsla(",hue,",100%,50%,0.8)"].join("");
}
