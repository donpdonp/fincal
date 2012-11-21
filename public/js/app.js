function ui_setup(prefix) {
  $('li#menu-calendar').click(go_calendar)
  $('li#menu-table').click(go_table)
  go_calendar();
  $('#calendar-view').fullCalendar({
    editable: true,
    events: prefix+"/data",
    eventClick: event_click,
    dayClick: day_click
  })
}

function go_calendar() {
  $('#menu-calendar').addClass('active')
  $('#menu-table').removeClass('active')
}

function go_table(date) {
  $('#menu-table').addClass('active')
  $('#menu-calendar').removeClass('active')
  var now = new XDate(date);
  $('div#table input#date').attr('value', now.toString("yyyy-MM-dd"));
  $('div#table').modal();
}

function event_click(e) {
  if (e.valueId) {
    console.log(e)
    $('form#detail').attr('action', e.valueId)
    $('div#detail div#name').text(e.title)
    $('div#detail div#date').text(e.start)
    $('div#detail').modal();
  }
}

function day_click(e) {
  go_table(e)
}
