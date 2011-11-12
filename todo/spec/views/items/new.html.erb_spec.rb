require 'spec_helper'

describe "items/new.html.erb" do
  before(:each) do
    assign(:item, stub_model(Item,
      :text => "MyString",
      :done => false,
      :order => 1
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_text", :name => "item[text]"
      assert_select "input#item_done", :name => "item[done]"
      assert_select "input#item_order", :name => "item[order]"
    end
  end
end
