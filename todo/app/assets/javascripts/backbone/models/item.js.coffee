class Todo.Models.Item extends Backbone.Model
  defaults: ->
    done: false

  toggle: ->
    @save(done: !@get('done'))
