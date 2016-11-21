{EventEmitter} = fbemitter

CHANGE_EVENT = 'change'

window.InterviewStore = _.assign(new EventEmitter(), {
    interviews: []


  getAll: ->
    @interview

  add: (interview) ->
    @interviews.push(interview)
    @emitChange()

  set: (interviews) ->
    @interviews = interviews
    @emitChange()

  remove: (interview)->
    @interviews = _.filter(@interviews, (_interview) -> _interview.id != interview.id)
    @emitChange()

  change: (interview, attributes)->
    interview = _.find(@interviews, (_interview) -> _interview.id == interview.id)
    _.assign(interview, attributes)
    @emitChange()

  emitChange: ->
    @emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @addListener(CHANGE_EVENT, callback)

  removeChangeListener: ->
    @removeAllListeners(CHANGE_EVENT)
})

dispatcher.register (payload) ->
  if payload.actionType == 'interview-add'
    InterviewStore.add(payload.interview)
  else if payload.actionType == 'interview-remove'
    InterviewStore.remove(payload.interview)
  else if payload.actionType == 'interview-change'
    InterviewStore.change(payload.interview, payload.attributes)
  else if payload.actionType == 'interview-set'
    InterviewStore.set(payload.interviews)
  
