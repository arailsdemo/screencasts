class Todo.Views.ItemView extends Backbone.View
  tagName: 'li'

  template: JST["backbone/templates/item"]

  events:
    "click .check"            : "toggleDone"
    "dblclick div.todo-text"  : "edit"
    "keypress .todo-input"    : "updateOnEnter"
    "click span.todo-destroy" : "clear"

  initialize: ->
    @model.bind('change', @render, @)
    @model.bind('destroy', @remove, @)

  render: ->
    $(@el).html(@template(@model.toJSON()))
    @setText()
    @

  setText: ->
    text = @model.get('text')
    @$('.todo-text').text(text)
    @input = @$('.todo-input')
    @input.bind('blur', _.bind(@close, @)).val(text)

  toggleDone: -> @model.toggle()

  edit: ->
    $(@el).addClass('editing')
    @input.focus()

  close: ->
    @model.save(text: @input.val())
    $(@el).removeClass('editing')

  updateOnEnter: (e) ->
    @close() if e.keyCode is 13

  clear: -> @model.destroy()

#  remove: -> $(@el).remove()
