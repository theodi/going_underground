describe('refreshPage', function() {
  beforeEach(function() {
    loadFixtures('start_stop.html');
    refreshPage(30000);
  });

  it('hides the off switch', function() {
    $('#stop-refresh').trigger("click");
    expect($('#stop')).toHaveClass('hidden');
    expect($('#start')).not.toHaveClass('hidden');
  });

  it('hides the on switch', function() {
    $('#start-refresh').trigger("click");
    expect($('#start')).toHaveClass('hidden');
    expect($('#stop')).not.toHaveClass('hidden');
  });
});
