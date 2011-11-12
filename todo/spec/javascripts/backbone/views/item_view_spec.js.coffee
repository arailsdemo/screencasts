describe "Views.ItemView", ->
  view = el = item = {}

  beforeEach ->
    Todo.Items = new Todo.Collections.ItemsCollection
    item = new Todo.Models.Item
    view = new Todo.Views.ItemView(model: item)
    el = $(view.el)

  afterEach ->
    Todo.Items.localStorage.records = []

  it "is contained in an 'li' by default", ->
    expect(view.el.nodeName).toEqual('LI')

  describe "rendering", ->
    it "does not have a checked checkbox when done is false", ->
      view.render()
      expect(el).not.toContain('input.check[checked="checked"]')

    it "has a checked checkbox when done is true", ->
      item.set(done: true)
      view.render()
      expect(el).toContain('input.check[checked="checked"]')

  describe "model bound events", ->
    it "rerenders when the model changes", ->
      expect(el).not.toContain('div.todo.done')
      item.set(done: true)
      expect(el).toContain('div.todo.done')

    it "removes itself when the model is destroyed", ->
      setFixtures('<ul id="foo"></ul>')
      $('#foo').html(view.render().el)
      expect($('#foo')).toContain('div.todo')
      item.destroy()
      expect($('#foo')).not.toContain('div.todo')

  describe "UI", ->
    beforeEach ->
      item.save(text: 'foo')  # needs to have item.collection defined for this to work
      setFixtures('<ul id="foo"></ul>')
      $('#foo').html(view.render().el)

    describe "on initial display", ->
      it "shows the item text in div.todo-text", ->
        expect($('div.todo-text', el).text()).toEqual('foo')

      it "show the item text in the input field", ->
        expect($('input.todo-input', el).val()).toEqual('foo')

    describe "when toggling done by clicking input.check", ->
      it "toggles done on the item", ->
        toggle_spy = sinon.spy(item, 'toggle')
        $('.check').click()
        expect(toggle_spy).toHaveBeenCalled()

    describe "when editing by double clicking div.todo-text", ->
      beforeEach -> $('div.todo-text').dblclick()

      it "gets an 'editing' class", ->
        expect($(view.el)).toHaveClass('editing')

      # fails in phantom.js. Passes in the browser
#      it "changes focus to the input field", ->
#        expect($('.todo-input:first', el).is(':focus')).toBeTruthy()

    describe "when Enter is pressed while in input.todo-input", ->
      input = {}
      beforeEach -> input = $('.todo-input', el)

      it "saves the item", ->
        save_spy = sinon.spy(item, 'save')
        input.val('bar').trigger($.Event('keypress', keyCode: 13))
        expect(save_spy).toHaveBeenCalledWith(text: 'bar')

      it "removes the editing class from the view", ->
        $('div.todo-text').dblclick()
        input.val('bar').trigger($.Event('keypress', keyCode: 13))
        expect($(view.el)).not.toHaveClass('editing')

    describe "when focus is lost", ->
      input = {}
      beforeEach -> input = $('.todo-input', el)

      it "saves the item", ->
        save_spy = sinon.spy(item, 'save')
        input.val('bar').blur()
        expect(save_spy).toHaveBeenCalledWith(text: 'bar')

      it "removes the editing class from the view", ->
        $('div.todo-text').dblclick()
        input.val('bar').blur()
        expect($(view.el)).not.toHaveClass('editing')

    describe "when clicking on span.todo-destroy", ->
      it "destroys the model", ->
        destroy_spy = sinon.spy(item, 'destroy')
        $('span.todo-destroy').click()
        expect(destroy_spy).toHaveBeenCalled()
