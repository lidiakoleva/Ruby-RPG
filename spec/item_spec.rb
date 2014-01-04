require_relative "../lib/item.rb"
require_relative "../lib/constants.rb"

describe Item do
  let (:item) { Item.new }

  it "has a name" do
    item.name.should be_kind_of String
  end

  it "has a description" do
    item.desrciption.should be_kind_of String
  end

  it "can be equipped" do
    item.should respond_to :equip

    context "and can only be equipped once" do
      before { sword = Item.new ; sword.equipped = false }
      sword.equip.should == Items::EQUIP
      item.should be_equipped
      item2.equip.should == Items::ALREADY_EQUIPPED
    end
  end

  it "has a set of attributes" do
    items.stats.should be_kind_of Hash
  end

  it "is equal to another item" do
    context "if name & description match" do
      sword = Item.new
      shield = Item.new
      sword.should == shield
    end
  end

end
