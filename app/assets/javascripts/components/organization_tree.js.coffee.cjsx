HSPACING = 10     # Horizontal spacing
VSPACING = 10     # Vertical spacing

NODE_RADIUS = 20
NODE_WIDTH = NODE_RADIUS * 2
NODE_HEIGHT = NODE_RADIUS * 2

# Given an employee, find out the width of the resulting tree
computeTreeWidth = (employee) ->
  @

# Given an employee, find out the height of the resulting tree
computeTreeHeight = (employee) ->
  @

TreeMixin = {
  getTreeWidth: (root) ->
    if root.children.count == 0
      NODE_WIDTH
    else
      totalWidth = 0
      for childRoot in root.children
        totalWidth += HSPACING unless totalWidth == 0
        totalWidth += @getTreeWidth(childRoot)

  getTreeHeight: (root) ->
    if root.children.count == 0
      NODE_HEIGHT
    else
      maxHeight = 0
      for childRoot in root.children
        maxHeight = Math.max(maxHeight, @getTreeHeight(childRoot))
      NODE_HEIGHT + SPACING + maxHeight
}

@OrganizationTree = React.createClass
  getInitialState: ->
    employees: []

  componentDidMount: ->
    $.get '/organization_structures.json', (data) =>
      @setState(employees: data)

  render: ->
    {employees} = @state
    <Canvas employees={employees} />

Canvas = React.createClass
  propTypes:
    employees: React.PropTypes.array

  render: ->
    {employees} = @props
    {drawTree} = @

    <svg width="800" height="600">
      {employees.map(renderTree)}
    </svg>

  renderTree: (employee) ->
    <Tree root={employee} />

Tree = React.createClass
  propTypes:
    root: React.PropTypes.object

  getWidth: ->
    @

  getHeight: ->
    @

  render: ->
    {root} = @props
    {renderSubtree} = @
    width = @getWidth()
    height = @getHeight()

    roots = employee.children

    <g>
      <Node item={root} />
      {roots.map(renderSubtree)}
    </g>

  renderSubtree: (root) ->
    <Tree root={root} />

  getWidthAndHeight: (tree) ->
    @

Node = React.createClass
  propTypes:
    item: React.PropTypes.object

  getWidth: -> NODE_RADIUS * 2
  getHeight: -> NODE_RADIUS * 2

  render: ->
    r = NODE_RADIUS
    {item} = @props

    <g>
      <circle x={r} y={r} r={r} />
      <text x={r} y={r}>{item.initial}</text>
    </g>
