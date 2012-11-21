function ui_setup(prefix) {
  $('#calendar-view').fullCalendar({
    editable: true,
    events: prefix+"/data",
    eventClick: event_click,
    dayClick: day_click
  })
  $('div#add-transaction form').submit(add_validate)
}

function add_validate(event) {
  var form = event.target

  var value_control = $('div#add-transaction div.control-group#amount')
  var value_help = $('div#add-transaction div.control-group#amount span.help-inline')
  var value_input = form['value[amount]']
  var value = parseInt(value_input.value)

  value_valid = value > 0
  if(!value_valid) {
    value_control.addClass('error')
    value_input.focus()
  }

  return value_valid
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
