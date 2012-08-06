     $(document).ready(function() {
      $('#calendar').fullCalendar({
      editable: true,
      events: [
        {
          title: '$40.25',
          start: new Date(2012, 7, 2)
        },
        {
          title: '$20.25',
          start: new Date(2012, 7, 3)
        },
        {
          title: '$50.25',
          start: new Date(2012, 7, 1)
        },
        {
          title: 'All Day Event',
          start: new Date(2012, 7, 1)
        },
        ]
      })
    })

