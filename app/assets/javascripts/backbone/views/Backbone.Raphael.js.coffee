class Backbone.RaphaelView extends Backbone.View
  delegateRaphaelEvents: (elements)->
    for name,element of elements
      @delegateRaphaelElementEvents name, element
  delegateRaphaelElementEvents: (name, element) ->
    events = [
      "mouseup"
      "mousedown"
      "mousemove"
      "mouseout"
      "click"
      "dblclick"
      "touchcancel"
      "touchend"
      "touchmove"
      "touchstart"
    ]
    for event in events
      element[event] (e) =>
        @.$el.trigger "raphael:#{name}:#{e.type}", e
    
