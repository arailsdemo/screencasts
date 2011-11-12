describe "Models.Item", ->
  item = {}

  beforeEach ->
    Todo.Items = { nextOrder: -> }
    item = new Todo.Models.Item

  describe "#defaults", ->
    it "has a default done value of false", ->
      item = new Todo.Models.Item
      expect(item.defaults().done).toEqual(false)

    it "sets the order attribute based on Todo.Items.nextOrder()", ->
      sinon.stub(Todo.Items, "nextOrder", -> 55)
      expect(item.defaults().order).toEqual(55)

  describe "#initialize", ->
    it "sets the collection to Todo.Items", ->
      expect(item.collection).toEqual(Todo.Items)



  describe "#toggle", ->
    save = {}

    beforeEach ->
      save = sinon.stub(item, 'save')

    it "toggles done from false to true via #save", ->
      item.toggle()
      expect(save).toHaveBeenCalledWith(done: true)

    it "toggles done from true to false via #save", ->
      item.set(done: true)
      item.toggle()
      expect(save).toHaveBeenCalledWith(done: false)
