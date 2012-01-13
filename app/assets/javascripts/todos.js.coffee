Todos = Ember.Application.create()

window.Todos = Todos

# Todos.Todo = Em.Object.extend
#   title: null
#   isDone: false

#############################
Todos.Todo = DS.Model.extend
  title: DS.attr('string')
  isDone: DS.attr('boolean')

Todos.Todo.reopenClass
  url: 'todo'

Todos.store = DS.Store.create
  adapter: DS.RESTAdapter.create(bulkCommit: false)

#############################

# controller
Todos.todosController = Em.ArrayProxy.create
  content: Todos.store.findAll(Todos.Todo)

  createTodo: (title) ->
    Todos.store.createRecord(Todos.Todo, title: title)

  clearCompletedTodos: ->
    @filterProperty('isDone', true).forEach (todo)->
      todo.deleteRecord()

  remaining: (->
    @filterProperty('isDone', false).get('length')
  ).property('@each.isDone')

  allAreDone: ((key, value) ->
    if value isnt undefined
      @setEach('isDone', value)
      return value
    else
      return !!@get('length') and @everyProperty('isDone', true)
  ).property('@each.isDone')

# views
Todos.StatsView = Em.View.extend
  remainingBinding: 'Todos.todosController.remaining'

  remainingString: (->
    remaining = @get('remaining')
    remaining + (if remaining is 1 then " item" else " items")
  ).property('remaining')

Todos.CreateTodoView = Em.TextField.extend
  insertNewline: ->
    value = @get('value')

    if value
      Todos.todosController.createTodo(value)
      @set('value', '')
