function ui_setup(prefix) {
  $('#calendar-view').fullCalendar({
    editable: true,
    events: prefix+"/data",
    eventClick: event_click,
    dayClick: day_click
  })
  $('div.add-transaction form').submit(add_validate)
}

function add_validate() {
  console.log("add validate")
}

function modal_add_transaction(date) {
  var now = new XDate(date);
  $('div#add-transaction input#date').attr('value', now.toString("yyyy-MM-dd"));
  $('div#add-transaction').modal();
}

function modal_delete(record) {
  $('form#detail').attr('action', record.valueId)
  $('div#detail div#name').text(record.title)
  $('div#detail div#date').text(record.start)
  $('div#detail').modal();
}

function event_click(e) {
  if (e.valueId) {
    modal_delete(e)
  }
}

function day_click(e) {
  modal_add_transaction(e)
}
