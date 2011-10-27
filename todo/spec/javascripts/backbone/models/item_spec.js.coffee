describe "Models.Item", ->
  describe "#defaults", ->
    it "has a default done value of false", ->
      item = new Todo.Models.Item
      expect(item.defaults().done).toEqual(false)

  describe "#toggle", ->
    item = save = {}

    beforeEach ->
      item = new Todo.Models.Item
      save = sinon.stub(item, 'save')

    it "toggles done from false to true via #save", ->
      item.toggle()
      expect(save).toHaveBeenCalledWith(done: true)

    it "toggles done from true to false via #save", ->
      item.set(done: true)
      item.toggle()
      expect(save).toHaveBeenCalledWith(done: false)
