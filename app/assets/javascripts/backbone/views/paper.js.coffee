class window.Paper extends Backbone.RaphaelView
  initialize: ->
    @p = Raphael @el, 800, 600
    @node = new Node
      parent: @
      p : @p
      x : 20
      y : 20
    @node1 = new Node
      parent : @
      p : @p
      x : 200
      y : 20
    @node2 = new Node
      parent : @
      p : @p
      x : 20
      y : 400
    @node3 = new Node
      parent : @
      p : @p
      x : 20
      y : 200
    @nodes = [
      @node
      @node1
      @node2
      @node3
    ]
  events:
    "out_port_selected" : "outPortSelected"
    "in_port_selected"  : "inPortSelected"
  outPortSelected: (j, node)->
    if not @current_node
      @current_node = node
      node.out_port.attr "fill", "#666666"
      for n in @nodes
        n.in_port.attr "fill", "#AAAAAA"
    else if @current_node == node
      @current_node = null
      node.out_port.attr "fill", node.OUT_PORT_COLOR
      for n in @nodes
        n.in_port.attr "fill", node.IN_PORT_COLOR
  inPortSelected: (j, node)->
    if @current_node
      edge = new Edge
        p : @p
        start : @current_node
        end :  node
      if @current_node.next
        @current_node.next.remove()
      @current_node.next = edge
      node.prev.push edge
      @current_node.out_port.attr "fill", node.OUT_PORT_COLOR
      @current_node = null
      for n in @nodes
        n.in_port.attr "fill", node.IN_PORT_COLOR
