InterviewWebUtil = ->
  request = (method, url, payload) ->
    $.ajax
      method: method
      url: url
      dataType: 'json'
      data: JSON.stringify(payload)
      contentType: 'application/json'
      beforeSend: ->
        $(".loader").show()
      complete: ->
        $(".loader").hide()

  fetchUpdateState = (intervieweeid,state) ->
    url = "interviews/state"
    payload =
      interview:
        id: intervieweeid
        state: state

    request("put", url, payload)

  fetchAddSchedule = (intervieweename, intervieweeemail, schedule) ->
    url = 'interviews'
    payload =
      interview:
        name: intervieweename
        email: intervieweeemail
        schedule: schedule

    request("post",url,payload)

  deleteSchedule = (intervieweeId) ->
    url = 'interviews/' + intervieweeId

    request("delete",url)

  fetchLoadInterviewees = (date) ->
    url = "interviews/interviewee"
    payload =
      interview:
        schedule: date.format('YYYY-MM-DD')

    request("post", url, payload)

  {
    fetchUpdateState: fetchUpdateState
    fetchAddSchedule: fetchAddSchedule
    deleteSchedule: deleteSchedule
    fetchLoadInterviewees: fetchLoadInterviewees
  }

window.InterviewWebUtil = InterviewWebUtil()
