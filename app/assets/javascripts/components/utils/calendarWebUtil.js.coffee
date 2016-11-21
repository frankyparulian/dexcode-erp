CalendarWebUtil = ->
  request = (method, url, payload) ->
    $.ajax
      method: method
      url: url
      dataType: 'json'
      data: JSON.stringify(payload)
      contentType: 'application/json'

  fetchBooked = (selected) ->
    url = 'interviews/interviewee'
    payload =
      interview:
        schedule: selected

    	request('post', url, payload)

    {
    fetchBooked: fetchBooked
    }

window.CalendarWebUtil = CalendarWebUtil()
