currentMousePos =
   top: -1
   left: -1

actions = true

$(document).mousemove (events) ->
  currentMousePos =
    top : events.pageY
    left : events.pageX
  true

@organizationContainer = React.createClass
  getInitialState : ->
    data : [],
    unparent: [],
    mouse_down_element : false,
    element_drag : parseInt(0),
    drag_x : 0,
    drag_y : 0,
    arrow : false

  componentDidMount : ->
    th = @
    $.get 'organization_structures/getdata', (data) =>
      global_data = data
      $(document).mousemove (events) ->
        th.setState
          drag_x : currentMousePos.left,
          drag_y : currentMousePos.top
      @setState
        data : data.data
        unparent : data.unparent
    $('body').not('.chart-field').click ->
      th.setState
        arrow: false
    true

  handleDeleteClick : (event)->
    state = @
    if confirm "Are you sure ?"
      $.ajax(
        url: 'organization_structures/'+event,
        type: 'DELETE',
        dataType: 'json'
        success: (data)->
          state.setState
            data: data.data
            unparent: data.unparent
      )

  handleDrag : (event, action, key)->
    if action.type == 'mouseup'
      target = action.target
      if action.dispatchMarker == '.0.0' || action.dispatchMarker == '.0.0.0'
        parent = 0
      else
        parent = $(target).parents('.element').attr('id')
        parent = parseInt(parent.replace('ch_',''))
      if @state.element_drag > 0 && (check_parent(parent, @state.element_drag) || parent == 0) && @state.element_drag != parent
        state = @
        $.post 'organization_structures/update_parent', {child: @state.element_drag, parent: parent}, (data) ->
          state.setState
            data: data.data
            unparent: data.unparent
      @setState
        mouse_down_element : false,
        element_drag : parseInt(0),
        arrow : false
    else if action.type == 'mousedown' && action.buttons == 1
      @setState
        mouse_down_element : true,
        element_drag : event,
        arrow : true

  render : ->
    <div>
      <div className="chart-field" onMouseUp={@handleDrag.bind(null, 0)}>
        <Rect data = {@state.data} DeleteClickEvent = {@handleDeleteClick} DragEvent={@handleDrag} Arrow={@state.arrow}/>
      </div>
      <div className='unparent-field'>
        <div className='title-unparent'></div>
        <DrawUnparentElement  data={@state.unparent} DragEvent={@handleDrag}/>
      </div>
      <DragElement Arrow={@state.arrow} Xelement={@state.drag_x} Yelement={@state.drag_y}/>
    </div>

DragElement = React.createClass
  render: ->
    style = {
      display : (if @props.Arrow then 'block' else 'none')
      left : @props.Xelement,
      top : (@props.Yelement + 10)
    }
    <div className="rect-helper" style={style}></div>

DrawUnparentElement = React.createClass
  render: ->
    if @props.data
      top = 20
      elem = []
      click_event = @props.DeleteClickEvent
      drag_event = @props.DragEvent
      elem.push @props.data.map (value, key)->
        tt= top

        top+=80
        <DrawRect dataName={value.name} dataPosition={value.position} positionLeft={10} positionTop={tt} dataId={value.id} dataParent="unparent" hasChild={true} DeleteClickEvent={click_event} hasAdd={false} dragEvent={drag_event}/>

      <svg width="220" height="800">
        {elem}
      </svg>

Rect = React.createClass
  render : ->
    element = draw @props.data, 1, 0, 0, @props.DeleteClickEvent, @props.DragEvent
    <svg width="#{element.total_width + 150}" height="#{element.total_height + 200}">
      <g transform="translate(0, -100)">{element.elem if @props.data != null && @props.data.length > 0 }</g>
    </svg>

DrawRect = React.createClass
  render: ->
    <g transform = "translate(#{@props.positionLeft}, #{@props.positionTop})" id="ch_#{@props.dataId}" data-parent={@props.dataParent} className="element">
      <rect x = "0" y="0" width="200" height="60" rx="3" ry="3" className="rect" onMouseDown={@props.dragEvent.bind(null, @props.dataId)} ></rect>
      <text x = "18" y= "20"  onMouseDown={@props.dragEvent.bind(null, @props.dataId)} >{@props.dataName}</text>
      <text x = "18" y= "50"  onMouseDown={@props.dragEvent.bind(null, @props.dataId)} >{@props.dataPosition}</text>
      <DrawDeleteButton hasDelete = {@props.hasChild} dataId={@props.dataId} DeleteClickEvent={@props.DeleteClickEvent}/>
      <DrawAddButton dataId = {@props.dataId} hasAdd={@props.hasAdd}/>
    </g>

DrawAddButton = React.createClass
  render : ->
    if @props.hasAdd
      style = {
        stroke: 'rgb(255,0,0)',
        strokeWidth : 2
      }
      <g className="add-button" transform="translate(100,60)" >
        <circle className="add-circle" ></circle>
      </g>
    else
      <g></g>

DrawDeleteButton = React.createClass
  render : ->
    unless @props.hasDelete
      <g className="close-button" transform="translate(195,5)" onClick={@props.DeleteClickEvent.bind(null,@props.dataId)}>
        <circle className="close-circle" ></circle>
        <text className="close-text">-</text>
      </g>
    else
      <g></g>

DrawPath = React.createClass
  render: ->
    {firstMoveX, firstMoveY, secondMoveX, secondMoveY, thirtMoveX, thirtMoveY,
      forthMoveX, forthMoveY, idChild} = @props

    <path d="M#{firstMoveX} #{firstMoveY} L#{secondMoveX} #{secondMoveY} L#{thirtMoveX} #{thirtMoveY} L#{forthMoveX} #{forthMoveY}" stroke="blue" strokeWidth="4" fill="none" id="pt_#{idChild}"/>

draw = (data, level, prev_width, parent, click_delete_handler, drag_event)->
  margin_left = 50;
  def_width = prev_width + margin_left
  def_top = (level * 100) + 50;
  elem = []
  result = {}
  total_width = prev_width
  child_width = 0
  self_width = 0
  result.child_attribut = []
  hasChild = true
  tot_height = 100
  if data != null
    data.forEach (value, key) ->
      unless typeof value.child == 'undefined' or value.child == 0
        child_data = {}
        child_data = draw value.child,level + 1,total_width, value.id, click_delete_handler, drag_event
        tot_height += child_data.total_height
        child_width = child_data.total_width
        child_data.elem.forEach (elem_value) ->
          if elem_value
            elem.push elem_value
      width_element = if child_width > 0 then child_width else 210
      left = total_width + (width_element / 2);
      total_width += width_element
      self_width += width_element
      unless typeof value.child == 'undefined' or value.child == 0
        child_data.child_attribut.forEach (ch_value) ->
          first_move_x = ch_value.x + 100
          first_move_y = ch_value.y
          second_move_x = first_move_x
          second_move_y = first_move_y - ((ch_value.y-(def_top+60))/2)
          thirt_move_x = left + 100
          thirt_move_y = second_move_y
          forth_move_x = thirt_move_x
          forth_move_y = second_move_y - ((ch_value.y-(def_top+60))/2)
          elem.push <DrawPath
            firstMoveX={first_move_x}
            firstMoveY={first_move_y}
            secondMoveX={second_move_x}
            secondMoveY={second_move_y}
            thirtMoveX={thirt_move_x}
            thirtMoveY={thirt_move_y}
            forthMoveX={forth_move_x}
            forthMoveY={forth_move_y}
            idChild={ch_value.id}
            idElement={value.id} />
        hasChild = true
      else
        hasChild = false
      elem.push <DrawRect dataName={value.name} dataPosition={value.position} positionLeft={left} positionTop={def_top} dataId={value.id} dataParent={parent} hasChild={hasChild} DeleteClickEvent={click_delete_handler} hasAdd={true} dragEvent={drag_event}/>
      child_attribut =
        x : left,
        y : def_top,
        id : value.id
      result.child_attribut.push child_attribut
  result.elem = elem
  result.total_width = self_width
  result.total_height = tot_height
  result


check_parent = (parent_id,my_id)->
  parent = $("#ch_"+parent_id).attr('data-parent')/1
  my_parent = $("#ch_"+my_id).attr('data-parent')/1
  if parent != my_id && parent_id > 0 && my_id > 0
    if parent == 0
      return true
    else
      ch_parent = check_parent parent, my_id
      if ch_parent then return true else return false
  else if my_parent == 0 && parent == 0
    return true
  else
    return false

get_translate = (translate) ->
  try
    translate = translate.replace("translate(", '').replace(')','')
    res = translate.split(",")
    result = {
      x: parseInt(res[0]),
      y: parseInt(res[1])
    }
    return result
  catch err
    console.error(err)
