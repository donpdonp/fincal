 $(document).ready(function() {
  $('#calendar').fullCalendar({
    editable: true,
    events: "/fincal/data"
  })
})
