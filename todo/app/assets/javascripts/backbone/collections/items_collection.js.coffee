class Todo.Collections.ItemsCollection extends Backbone.Collection
  model: Todo.Models.Item

  localStorage: new Store('items')

  nextOrder: ->
    return 1 unless @length
    @last().get('order') + 1

  done: ->
    @filter (item) -> item.get('done')

  remaining: -> @without.apply(@, @done())

  comparator: (todo) -> todo.get('order')
