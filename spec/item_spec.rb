require_relative "../lib/item.rb"
require_relative "../lib/constants.rb"
require_relative "../lib/player.rb"

describe Item do
  let (:item) {Item.new "Health potion", 'delicious juice', {:current_hp => 15}}
  let (:sword) {
  Item.new "The sword of epicness",
    'the best sword in the world!',
    {:damage => 20},
    Items::WEAPON}
  let(:player) { Player.new "John" }

  it "has a name" do
    item.name.should be_kind_of String
  end

  it "has a description" do
    item.description.should be_kind_of String
  end

  it "has a set of attributes" do
    item.stats.should be_kind_of Hash
  end

  it "can be equipped" do
    item.should respond_to :equip
  end

  it "can only be equipped once" do
    player.pick_up(sword)
    player.equip(sword).should == Items::EQUIP
    sword.should be_equipped
    sword.equip.should == Items::ALREADY_EQUIPPED
  end

  it "is equal to another item" do
    potion1 = Item.new
    potion2 = Item.new
    potion1.should == potion2
  end

end
