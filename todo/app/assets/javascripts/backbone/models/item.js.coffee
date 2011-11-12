class Todo.Models.Item extends Backbone.Model
  initialize: ->
    @collection = Todo.Items

  defaults: ->
    done: false
    order: Todo.Items.nextOrder()

  toggle: ->
    @save(done: !@get('done'))
