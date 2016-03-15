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

    $('#from-date input').blur(function() {
      dateFrom = moment(this.value)
      dateTo = $('#to-date').data("DateTimePicker")
      dateTo.maxDate(dateFrom.endOf('day').format())
      dateTo.minDate(dateFrom.startOf('day').format())
      dateTo.date(dateFrom.add(1, 'hours').format())
    })

  });
}
