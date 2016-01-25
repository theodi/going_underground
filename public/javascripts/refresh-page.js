function refreshPage(reloadTime) {
  var reload = setTimeout(function() {
    location.reload();
  }, reloadTime);

  $("#stop-refresh").click(function(e) {
    clearTimeout(reload);
    $('.auto-refresh#start').removeClass('hidden');
    $('.auto-refresh#stop').addClass('hidden');
    return false;
  });

  $('#start-refresh').click(function(e) {
    setTimeout(reload)
    $('.auto-refresh#stop').removeClass('hidden');
    $('.auto-refresh#start').addClass('hidden');
    return false;
  });
}
