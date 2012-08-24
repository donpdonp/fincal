/* Backbone.js */
var Journal = Backbone.Collection.extend({
  model: Value
});

var Value = Backbone.Model.extend({
  set: function(attributes, options) {
    Backbone.Model.prototype.set.call(this, attributes, options);
  }
});

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