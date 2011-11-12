require 'spec_helper'

describe "items/edit.html.erb" do
  before(:each) do
    @item = assign(:item, stub_model(Item,
      :text => "MyString",
      :done => false,
      :order => 1
    ))
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path(@item), :method => "post" do
      assert_select "input#item_text", :name => "item[text]"
      assert_select "input#item_done", :name => "item[done]"
      assert_select "input#item_order", :name => "item[order]"
    end
  end
end
