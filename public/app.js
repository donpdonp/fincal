 $(document).ready(function() {
  $('#calendar').fullCalendar({
    editable: true,
    events: "/fincal/data"
  })
})

function go_calendar() {
  $('#table').hide();
  $('#calendar').show();
}

function go_table() {
  $('#table').show();
  $('#calendar').hide();
}