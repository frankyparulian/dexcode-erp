{EventEmitter} = fbemitter

CHANGE_EVENT = 'change'

window.CalendarStore = _.assign(new EventEmitter(), {
  calendar: {
    booked: [],
    current: moment(),
    selected: moment(),
    schedule: null
  }


  get: ->
    @calendar

  update: (calendar) ->
    @calendar = _.assign({}, @calendar, calendar)
    console.log('@calendar', @calendar)
    @emitChange()

  setBook: (booked) ->
    @calendar.booked = booked
    @emitChange()

  emitChange: ->
    @emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @addListener(CHANGE_EVENT, callback)

  removeChangeListener: ->
    @removeAllListener(CHANGE_EVENT)
})

dispatcher.register (payload) ->
  switch payload.actionType
    when 'calendar-update'
      console.log("dispatcher schedule",payload);
      CalendarStore.update(payload.calendar)
    when 'calendar-booked-add'
      CalendarStore.setBook(payload.booked)
