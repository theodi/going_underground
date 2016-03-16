function callDatePicker() {
  $.getJSON('/cromulent-dates', function(json) {
    setDatePickers(json.start, json.end)
  });

  $('#from-date input').blur(function() {
    updateToDate(moment(this.value))
  })
}

function setDatePickers(start, end) {
  var format = 'YYYY-MM-DD HH:mm:ss'

  $('#from-date').datetimepicker({
    format: format,
    useCurrent: false,
    minDate: start,
    maxDate: end
  });

  $('#to-date').datetimepicker({
    format: format,
    useCurrent: false,
    minDate: start,
    maxDate: end
  });
}

function updateToDate(date) {
  datePicker = $('#to-date').data("DateTimePicker")
  setDates(datePicker, date)
}

function setDates(datePicker, date) {
  datePicker.date(date.add(1, 'hours').format())
  datePicker.maxDate(date.endOf('day').format())
  datePicker.minDate(date.startOf('day').format())
}
