
require_relative "../lib/item.rb"

describe Item do
  let (:potion) {Item.new "Health potion", 'delicious juice', {:current_hp => 15}}

  it "has a name" do
    potion.name.should be_kind_of String
  end

  it "has a description" do
    potion.description.should be_kind_of String
  end

  it "has a set of attributes" do
    potion.stats.should be_kind_of Hash
  end

  it "is equal to another item" do
    potion1 = Item.new "Health potion", 'delicious juice', {:current_hp => 15}
    potion2 = Item.new "Health potion", 'delicious juice', {:current_hp => 15}
    potion1.should == potion2
  end

end
