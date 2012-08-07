$(document).ready(function() {
  go_calendar();
  $('#calendar').fullCalendar({
    editable: true,
    events: "/fincal/data"
  })
})

function go_calendar() {
  $('#table').hide();
  $('#calendar').show();
  $('#menu-calendar').addClass('active')
  $('#menu-table').removeClass('active')
}

function go_table() {
  $('#table').show();
  $('#calendar').hide();
  $('#menu-table').addClass('active')
  $('#menu-calendar').removeClass('active')
}