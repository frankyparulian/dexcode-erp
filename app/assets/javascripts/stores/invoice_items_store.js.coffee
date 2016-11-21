{EventEmitter} = fbemitter

CHANGE_EVENT = 'change'

generateTimestamp = ->
  parseInt(window.performance.now() * 1000000)

window.InvoiceItemsStore = _.assign(new EventEmitter(), {
  items: []

  getItems: ->
    @items

  setItems: (items) ->
    for item in items
      item.key = generateTimestamp()
    @items = items
    @emitChange()

  addBlankItem: ->
    @addItem({ key: generateTimestamp(), type: 'fixed' })

  addItem: (item) ->
    @items.push(item)
    @emitChange()

  removeItem: (item) ->
    item = _.find(@items, (_item) -> _item.key == item.key)
    item._destroy = 1
    @emitChange()

  changeItem: (item, attributes) ->
    item = _.find(@items, (_item) -> _item.key == item.key)
    _.assign(item, attributes)
    @emitChange()

  emitChange: ->
    @emit(CHANGE_EVENT)

  addChangeListener: (callback) ->
    @addListener(CHANGE_EVENT, callback)

  removeChangeListener: ->
    @removeAllListeners(CHANGE_EVENT)
})

dispatcher.register (payload) ->
  if payload.actionType == 'invoice-items-add'
    InvoiceItemsStore.addItem(payload.item)
  else if payload.actionType == 'invoice-items-add-blank'
    InvoiceItemsStore.addBlankItem()
  else if payload.actionType == 'invoice-items-remove'
    InvoiceItemsStore.removeItem(payload.item)
  else if payload.actionType == 'invoice-items-change'
    InvoiceItemsStore.changeItem(payload.item, payload.attributes)
