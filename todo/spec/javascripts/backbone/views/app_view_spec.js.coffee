Utils ?= {}
Utils.setupItems = (items)->
  items.add(new Todo.Models.Item(done: true))
  for num in [1..2]
    items.add(new Todo.Models.Item)

describe "Views.AppView", ->
  view = items = {}

  beforeEach ->
    setFixtures '''
                <div id="todoapp">
                  <div class="content">
                    <div id="create-todo">
                      <input id="new-todo" placeholder="What needs to be done?" type="text" />
                      <span class="ui-tooltip-top" style="display:none;">Press Enter to save this task</span>
                    </div>
                    <div id="todos">
                      <ul id="todo-list"></ul>
                    </div>
                    <div id="todo-stats"></div>
                  </div>
                </div>
                '''
    view = new Todo.Views.AppView
    items = Todo.Items

  afterEach ->
    Todo.Items.localStorage.records = []

  describe "#initialize", ->
    it "sets the Todo.Items to a new ItemsCollection", ->
      expect(items instanceof Todo.Collections.ItemsCollection).toBeTruthy()

    it "loads the existing items into the Todo.Items", ->
      for num in [1..2]
        item = new Todo.Models.Item
        item.save()

      new Todo.Views.AppView
      expect(Todo.Items.length).toEqual(2)

  describe "rendered stats template", ->
    describe "when no items are present", ->
      it "doesn't have a span.todo-count", ->
        view.render()
        expect($('#todoapp')).not.toContain('span.todo-count')

      it "doesn't have a span.todo-clear", ->
        view.render()
        expect($('#todoapp')).not.toContain('span.todo-clear')

    describe "when 1 done and 2 pending item are present", ->
      beforeEach -> Utils.setupItems(items)

      it "displays the counts in span.todo-count", ->
        view.render()
        expect($('#todoapp #todo-stats')).toContain('span.todo-count')
        expect($('span.number')).toHaveHtml('2')
        expect($('span.word')).toHaveHtml('items')

      it "displays the clear link in span.todo-clear", ->
        view.render()
        expect($('#todoapp')).toContain('span.todo-clear')
        expect($('span.number-done')).toHaveHtml('1')
        expect($('span.word-done')).toHaveHtml('item')

  describe "collection bound events", ->
    it "appends the model's view HTML to #todo-list when a model is added to Todo.Items", ->
      item = new Todo.Models.Item(text: 'foobar')
      Todo.Items.add(item)
      expect($('#todo-list')).toContain(".todo-text:contains('foobar')")

    it "appends all the given models' HTML to #todo-list when the Todo.Items is reset", ->
      Todo.Items.reset([{text: 'foo'}, {text: 'bar'}])
      expect($('#todo-list')).toContain(".todo-text:contains('foo')")
      expect($('#todo-list')).toContain(".todo-text:contains('bar')")

    it "re-renders the stats when any event is triggered on the Todo.Items", ->
      items.create(text: 'foobar')
      expect($('span.todo-count')).toContain("span.number:contains('1')")

      items.remove(items.last())
      expect($('span.todo-count')).not.toContain("span.number")

  describe "UI", ->
    describe "when clicking on the .todo-clear link", ->
      it "removes all completed tasks", ->
        Utils.setupItems(items)
        view.render()

        $('.todo-clear a').click()
        expect($('#todoapp')).not.toContain('div.todo.done')
        expect($('#todoapp')).toContain('div.todo')

    describe "when in the #new-todo input field", ->
      beforeEach -> view.render()

      it "saves the item if there is text and Enter is pressed", ->
        $("#new-todo").val('foo').trigger($.Event('keypress', keyCode: 13))
        expect($('ul#todo-list')).toContain('div.todo-text:contains(foo)')

      it "clears the text if the item is saved", ->
        $("#new-todo").val('foo').trigger($.Event('keypress', keyCode: 13))
        expect($("#new-todo").val()).not.toEqual('foo')

      it "doesn't save the item if text is missing", ->
        $("#new-todo").trigger($.Event('keypress', keyCode: 13))
        expect($('ul#todo-list')).not.toContain('div.todo-text')

      it "doesn't save the item if there is text and a non-Enter key is pressed", ->
        $("#new-todo").val('foo').trigger($.Event('keypress', keyCode: 100))
        expect($('ul#todo-list')).not.toContain('div.todo-text:contains(foo)')

      describe "when showing the tooltip", ->
        clock = {}
        beforeEach -> clock = sinon.useFakeTimers()
        afterEach -> clock.restore()

        it "shows the toolip 1s after a keyup", ->
          $("#new-todo").val('foo').trigger($.Event('keyup', keyCode: 50))
          clock.tick 1001
          expect($('span.ui-tooltip-top')).toBeVisible()

        it "hides the tooltip after another keyup", ->
          $("#new-todo").trigger($.Event('keyup', keyCode: 50))
          clock.tick 1001
          $("#new-todo").trigger($.Event('keyup', keyCode: 50))
          clock.tick 403
          expect($('span.ui-tooltip-top')).not.toBeVisible()

        it "doesn't show the tooltip if the input is blank", ->
          $("#new-todo").trigger($.Event('keyup'))
          clock.tick 2000
          expect($('span.ui-tooltip-top')).not.toBeVisible()

        it "doesn't show the tooltip if the input is the placeholder", ->
          placeholder = $('input#new-todo').attr('placeholder')
          $('#new-todo').val(placeholder)
          $("#new-todo").trigger($.Event('keyup'))
          clock.tick 2000
          expect($('span.ui-tooltip-top')).not.toBeVisible()

        it "doesn't show the toolip if the next keyup happens within 1s", ->
          $("#new-todo").val('foo').trigger($.Event('keyup', keyCode: 50))
          clock.tick 999
          $("#new-todo").trigger($.Event('keyup', keyCode: 50))
          clock.tick 10
          expect($('span.ui-tooltip-top')).not.toBeVisible()
