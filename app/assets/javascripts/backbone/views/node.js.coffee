#  Node is a doubly linked list.  It accepts multiple inputs but only one output.
#  It is doubly linked because when we drag it we want to update the edges between nodes
#  The nodes can be drag around, and when a out port is clicked (box on the right side),
#  you can then click another nodes in port and an edge will link them.
class window.Node extends Backbone.RaphaelView
  WIDTH: 100
  HEIGHT: 100
  PORT_WIDTH:20
  PORT_HEIGHT:20
  OUT_PORT_COLOR:"#AA55BB"
  IN_PORT_COLOR: "#AABB55"
  initialize: ->
    @parent = @options.parent  #  Parent View
    @p = @options.p            #  Raphael Paper to draw on
    @x = @options.x
    @y = @options.y

    @render()                  # draw box and ports

    @delegateRaphaelEvents     # delegate Raphael Events for Event objects
      box: @box
      in_port: @in_port
      out_port: @out_port

    @prev = []                # initialize prev and next to an empty array and null
    @next = null

  events: ->
    "raphael:box:mousedown" : "startMove"
    "raphael:box:mousemove" : "processMove"
    "raphael:box:mouseup"   : "stopMove"
    "raphael:box:mouseout"  : "outMove"
    "raphael:out_port:click": "outPortSelected"
    "raphael:in_port:click": "inPortSelected"

  #  @parent handles interactions between nodes.  We inform the parent that a port was 
  #  clicked.
  #  I'm not sure if this how I want to inform @parent that the port was selected
  #  but it works for now...
  outPortSelected: (j, e) ->
    @parent.$el.trigger "out_port_selected", @
  inPortSelected: (j, e) ->
    @parent.$el.trigger "in_port_selected", @

  # Handle draggable box
  outMove: (j, e)->
    if @dragging
      @processMove j, e
      @dragging = false
  startMove: (j, e)->
    @dragging = true
    @ox = e.offsetX
    @oy = e.offsetY
  processMove: (j, e)->
    if @dragging
      dx = e.offsetX - @ox
      dy = e.offsetY - @oy
      @set.translate dx, dy
      @ox = e.offsetX
      @oy = e.offsetY
      @x += dx
      @y += dy
      #  update edges between nodes
      if @next
        @next.update()
      if @prev.length > 0
        for edge in @prev
          edge.update()
  stopMove: (j, e)->
    @dragging = false
  
  # Used to draw edge in parent.
  out: ->
    {
      x: @x + @WIDTH + @PORT_WIDTH
      y: @y + @HEIGHT/2
    }
  in: ->
    {
      x: @x - @PORT_WIDTH
      y: @y + @HEIGHT/2
    }

  render: ->
    if @box
      @box.remove()
    @box = @p.rect @x,@y,@WIDTH,@HEIGHT, 5
    @in_port = @p.rect @x - @PORT_WIDTH, @y + @HEIGHT/2 - @PORT_HEIGHT/2, @PORT_WIDTH, @PORT_HEIGHT, 3
    @out_port = @p.rect @x + @WIDTH, @y + @HEIGHT/2 - @PORT_HEIGHT/2, @PORT_WIDTH, @PORT_HEIGHT, 3
    @set = @p.set [
      @box
      @in_port
      @out_port
    ]
    @box.attr "fill", "#55AABB"
    @in_port.attr "fill", @IN_PORT_COLOR
    @out_port.attr "fill", @OUT_PORT_COLOR
