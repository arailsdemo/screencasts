Todos = Ember.Application.create()

window.Todos = Todos

Todos.Todo = Em.Object.extend
  title: null
  isDone: false

Todos.todosController = Em.ArrayProxy.create
  content: []

  createTodo: (title) ->
    todo = Todos.Todo.create(title: title)
    @pushObject(todo)

Todos.CreateTodoView = Em.TextField.extend
  insertNewline: ->
    value = @get('value')

    if value
      Todos.todosController.createTodo(value)
      @set('value', '')
