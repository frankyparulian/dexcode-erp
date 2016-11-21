_ = require('lodash')

InvoiceItemsForm = React.createClass
  getInitialState: ->
    {
      invoiceItems: InvoiceItemsStore.getItems()
    }

  componentDidMount: ->
    InvoiceItemsStore.addChangeListener(@_onChange)

  componentWillUnmount: ->
    InvoiceItemsStore.removeChangeListener(@_onChange)

  render: ->
    {onDidClickAddItem} = @
    {invoiceItems} = @state
    invoiceItems ||= []

    invoiceItemComponent = (invoiceItem) ->
      index = invoiceItem.id || invoiceItem._index
      <InvoiceItemsFormItem invoiceItem={invoiceItem} index={index} />

    <div className="invoice-items-form">
      <table className="table">
        <thead>
          <tr>
            <th>Name</th>
            <th className='cell-type'>Type</th>
            <th className='cell-quantity'>Quantity</th>
            <th>Unit Price</th>
            <th>Amount</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {invoiceItems.map(invoiceItemComponent)}
        </tbody>
      </table>

      <button className="button button-default" onClick={onDidClickAddItem}>Add Item</button>
    </div>

  onDidClickAddItem: (event) ->
    event.preventDefault()
    dispatcher.dispatch({ actionType: 'invoice-items-add-blank' })

  _onChange: ->
    @setState(invoiceItems: InvoiceItemsStore.getItems())

InvoiceItemsFormItem = React.createClass
  propTypes:
    invoiceItem: React.PropTypes.object.isRequired
    index: React.PropTypes.number.isRequired

  render: ->
    {calculatePrice, onDidChangeTypeInput, onInputQuantity,
      onInputUnitPrice, onInputAmount, onInputItemName, onClickRemoveItem} = @
    {invoiceItem, index} = @props
    {id, name, type, quantity, unit_price, amount} = invoiceItem

    inputNamePrefix = "invoice[invoice_items_attributes][]"
    idHiddenInputName = "#{inputNamePrefix}[id]"
    nameInputName = "#{inputNamePrefix}[name]"
    typeInputName = "#{inputNamePrefix}[type]"
    quantityInputName = "#{inputNamePrefix}[quantity]"
    unitPriceInputName = "#{inputNamePrefix}[unit_price]"
    amountInputName = "#{inputNamePrefix}[amount]"

    if invoiceItem._destroy == 1
      destroyInputName = "#{inputNamePrefix}[_destroy]"
      destroyHiddenInput = <input name={destroyInputName} value=1 className="form-control" type="hidden" />
      hiddenAttribute = { display: 'none' }
    else
      hiddenAttribute = {}

    idHiddenInput = <input name={idHiddenInputName} value={index} className="form-control" type="hidden" />
    itemNameInput = <input type="text" name={nameInputName} value={name} className="form-control" onInput={onInputItemName} />
    selectInput = <select name={typeInputName} value={type} className="form-control" onChange={onDidChangeTypeInput}>
      <option value="fixed">Fixed</option>
      <option value="per_unit">Hourly</option>
    </select>

    quantityInput = if type == 'per_unit' then <input type="text" name={quantityInputName} value={quantity} className="form-control" onInput={onInputQuantity} /> else null
    unitPriceInput = if type == "per_unit" then <input type="text" name={unitPriceInputName} value={unit_price} className="form-control" onInput={onInputUnitPrice} /> else null
    amountInput = if type == 'fixed' then <input type="text" name={amountInputName} value={amount} className='form-control' onInput={onInputAmount} /> else <span>{calculatePrice(unit_price, quantity)}<input type="hidden" name={amountInputName} value={calculatePrice(unit_price, quantity)} /></span>

    <tr style={hiddenAttribute}>
      {idHiddenInput}
      {destroyHiddenInput}
      <td>{itemNameInput}</td>
      <td className='cell-type'>{selectInput}</td>
      <td className='cell-quantity'>{quantityInput}</td>
      <td>{unitPriceInput}</td>
      <td>{amountInput}</td>
      <td><IconButton iconClassName="glyphicon glyphicon-remove" tooltip="Remove" onClick={onClickRemoveItem} /></td>
    </tr>

  calculatePrice: (unitPrice, quantity) ->
    return '' unless unitPrice and quantity
    unitPrice * quantity

  _dispatchChangeEvent: (attributes) ->
    dispatcher.dispatch(
      actionType: 'invoice-items-change'
      item: @props.invoiceItem
      attributes: attributes
    )


  onDidChangeTypeInput: (event) ->
    @_dispatchChangeEvent(type: event.target.value)

  onInputAmount: (event) ->
    @_dispatchChangeEvent(amount: event.target.value)

  onInputItemName: (event) ->
    @_dispatchChangeEvent(name: event.target.value)

  onInputUnitPrice: (event) ->
    @_dispatchChangeEvent(unit_price: event.target.value)

  onInputQuantity: (event) ->
    @_dispatchChangeEvent(quantity: event.target.value)

  onClickRemoveItem: (event) ->
    event.preventDefault()
    dispatcher.dispatch({
      actionType: 'invoice-items-remove'
      item: @props.invoiceItem
    })

window.InvoiceItemsForm = InvoiceItemsForm
