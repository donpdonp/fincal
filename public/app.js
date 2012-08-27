
$(document).ready(function() {
  ui_setup();
  go_calendar();
  $('#calendar-view').fullCalendar({
    editable: true,
    events: "/fincal/data"
  })
})

function ui_setup() {
  $('li#menu-calendar').click(go_calendar)
  $('li#menu-table').click(go_table)
}

function go_calendar() {
  $('#menu-calendar').addClass('active')
  $('#menu-table').removeClass('active')
}

function go_table() {
  $('#menu-table').addClass('active')
  $('#menu-calendar').removeClass('active')
  $('div#table').modal();
}