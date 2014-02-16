require_relative "../lib/player.rb"
require_relative "../lib/item.rb"
require_relative "../lib/constants.rb"

describe "Player" do
  let (:player) { Player.new "Doctor Who" }
  let (:sword) {
    Item.new "The sword of epicness",
      'the best sword in the world!',
      {:damage => 20},
      :weapon}

  it "has a name" do
    player.should respond_to :name
  end

  it "has expirience" do
    player.should respond_to :xp
  end

  it "has a level" do
    player.should respond_to :level
  end

  it "has items" do
    player.should respond_to :inventory
  end

  it "can pick up items (if the inventory is not full)" do
    player.pick_up(sword).should == :pick_up
  end

  it "has stats" do
    player.stats.should be_kind_of Hash
  end

end