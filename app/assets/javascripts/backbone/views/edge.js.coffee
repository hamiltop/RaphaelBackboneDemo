class window.Edge extends Backbone.RaphaelView
  initialize: ->
    @p = @options.p
    @start = @options.start
    @end   = @options.end
    @line = @p.path @path()
    @line.attr "stroke-width", 5
  path: ->
    "M#{@start.out().x},#{@start.out().y} L#{@end.in().x},#{@end.in().y}"
  update: ->
    @line.attr "path", @path()
  remove: ->
    @line.remove()
