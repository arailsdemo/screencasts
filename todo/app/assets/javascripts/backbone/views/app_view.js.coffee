class Todo.Views.AppView extends Backbone.View
  el: "#todoapp"  # don't use $('#todoapp')

  statsTemplate: JST["backbone/templates/stats"]

  events:
    "click .todo-clear a" : "clearCompleted"
    "keypress #new-todo"  : "createOnEnter"
    "keyup #new-todo"     : "showTooltip"

  initialize: ->
    @input = @$('#new-todo')

    Todo.Items = new Todo.Collections.ItemsCollection
    Todo.Items.bind('add', @addOne, @)
    Todo.Items.bind('reset', @addAll, @)
    Todo.Items.bind('all', @render, @)

    Todo.Items.fetch()

  render: ->
    @$('#todo-stats').html(@statsTemplate(
      total    : Todo.Items.length
      done     : Todo.Items.done().length
      remaining: Todo.Items.remaining().length
    ))

  addOne: (item) ->
    view = new Todo.Views.ItemView(model: item)
    @$('#todo-list').append(view.render().el)

  addAll: ->
    Todo.Items.each(@addOne)

  clearCompleted: ->
    _.each Todo.Items.done(), (todo) ->
      todo.destroy()
    return false  # prevent from following the link

  createOnEnter: (e) ->
    text = @input.val()
    return unless text and e.keyCode is 13
    Todo.Items.create(text: text)
    @input.val('')

  showTooltip: (e) ->
    tooltip = @$(".ui-tooltip-top")
    val = @input.val()
    tooltip.fadeOut()
    clearTimeout(@tooltipTimeout) if @tooltipTimeout

    return if val is '' or val is @input.attr('placeholder')

    show = -> tooltip.show().fadeIn()
    @tooltipTimeout = _.delay(show, 1000)
