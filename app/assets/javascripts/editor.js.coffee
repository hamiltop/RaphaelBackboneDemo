# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Node
  width: 80
  height: 100
  port_height: 20
  port_width: 20
  box_radius: 3
  port_radius: 2
  in_port_color: "blue"
  out_port_color: "green"
  constructor: (paper, x, y) ->
    @paper = paper
    @box_x = x
    @box_y = y
    @in_port_x = x - @port_width
    @in_port_y = y + @height/2 - @port_height/2
    @out_port_x = x + @width
    @out_port_y = y + @height/2 - @port_height/2
    @selected = false
    @draw()
    @set_events()
  addIn: (other) ->
    @in = other
    other.addOut @
    $(@paper).trigger("render")
  addOut: (other) ->
    @out = other
  draw: ->
    @box = @paper.rect(@box_x, @box_y, @width, @height, @box_radius)
    @in_port = @paper.rect(@in_port_x, @in_port_y, @port_width, @port_height, @port_radius)
    @out_port = @paper.rect(@out_port_x, @out_port_y, @port_width, @port_height, @port_radius)
    @set = @paper.set [
      @box
      @in_port
      @out_port
    ]
    @clear_highlights()
  highlight_in_port: ->
    @in_port.attr("fill", "yellow")
  highlight_out_port: ->
    @out_port.attr("fill", "red")
  clear_highlights: ->
    @in_port.attr("fill", @in_port_color)
    @out_port.attr("fill", @out_port_color)
  set_events: ->
    @out_port.click (e) =>
      if @selected
        @clear_highlights()
        $(@paper).trigger "deselect:output", @
        @selected = false
      else
        @highlight_out_port()
        $(@paper).trigger "select:output", @
        @selected = true
    @in_port.click (e) =>
      $(@paper).trigger "select:input", @
    onstart = ->
    onend = ->
    onmove = (dx,dy,x,y) =>
      @set.translate(dx,dy)
    @box.drag(onmove, onstart, onend)
        
class Edge
  constructor: (paper, node0, node1) ->
    x0 = node0.out_port_x + node0.port_width/2
    x1 = node1.in_port_x + node1.port_width/2
    y0 = node0.out_port_y + node0.port_height/2
    y1 = node1.out_port_y + node1.port_height/2
    @line = paper.path "M#{x0},#{y0} L#{x1},#{y1}"
    @line.toBack()
    
  

$ ->
  paper = Raphael(0, 0, 600, 600)
  window.nodes = []
  window.lines = []
  nodes.push new Node(paper, 50, 50)
  nodes.push new Node(paper, 150, 150)
  selected_node = null
  $(paper).bind "select:output", (e,node) ->
    selected_node = node
    $.each nodes, (i,el) ->
      el.highlight_in_port()
  $(paper).bind "deselect:output", (e,node) ->
    selected_node = null
    $.each nodes, (i,el) ->
      el.clear_highlights()
  $(paper).bind "select:input", (e,node) ->
    if selected_node
      node.addIn selected_node
      $.each nodes, (i,el) ->
        el.clear_highlights()
  $(paper).bind "render", (e) ->
    $.each lines, (i, el) ->
      el.line.remove()
    $.each nodes, (i,el) ->
      if el.out
        lines.push new Edge(paper, el, el.out)
        
    
      
