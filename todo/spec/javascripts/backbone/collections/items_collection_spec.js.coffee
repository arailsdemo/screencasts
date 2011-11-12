describe "Collections.ItemsCollection", ->
  items = {}

  beforeEach ->
    items = Todo.Items = new Todo.Collections.ItemsCollection

  afterEach ->
    Todo.Items.localStorage.records = []

  it "has a model of Item", ->
    expect(items.model).toEqual(Todo.Models.Item)

  it "has a localStorage of Store", ->
    expect(items.localStorage instanceof Store).toBeTruthy()

  describe "#nextOrder", ->
    it "returns 1 if there are no items", ->
      expect(items.nextOrder()).toEqual(1)

    it "returns the last item's order + 1 if there are items", ->
      for num in [1..2]
        items.add new Todo.Models.Item

      expect(items.nextOrder()).toEqual(3)

  describe "scopes", ->
    item1 = item2 = item3 = item4 = items = {}

    beforeEach ->
      item1 = new Todo.Models.Item
      item2 = new Todo.Models.Item(done: true)
      item3 = new Todo.Models.Item
      item4 = new Todo.Models.Item(done: true)
      items = new Todo.Collections.ItemsCollection([item1, item2, item3, item4])

    describe "#done", ->
      it "returns an array of items that are done", ->
        results = items.done().map((item) -> item.get('done'))
        expect(results).toEqual [true, true]

    describe "#remaining", ->
      it "returns an array of items that are not done", ->
        results = items.remaining().map (item) -> item.get('done')
        expect(results).toEqual [false, false]

    describe "#comparator", ->
      it "returns the order attribute of the passed in argument", ->
        item = new Todo.Models.Item
        expect(items.comparator(item)).toEqual(item.get('order'))
