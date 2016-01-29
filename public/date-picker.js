function callDatePicker() {
  $.getJSON('/cromulent-dates', function(json) {
    var format = 'YYYY-MM-DD HH:mm:ss'

    $('#from-date').datetimepicker({
      format: format,
      useCurrent: false,
      minDate: json.start,
      maxDate: json.end
    });

    $('#to-date').datetimepicker({
      format: format,
      useCurrent: false,
      minDate: json.start,
      maxDate: json.end
    });

    $("#from-date").on("dp.change", function (e) {
        $('#to-date').data("DateTimePicker").minDate(e.date);
    });
    $("#to-date").on("dp.change", function (e) {
        $('#from-date').data("DateTimePicker").maxDate(e.date);
    });
  });
}
