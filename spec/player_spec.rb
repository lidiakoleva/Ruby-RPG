require_relative "../lib/player.rb"
require_relative "../lib/item.rb"
require_relative "../lib/constants.rb"

describe "Player" do
  let (:player) { Player.new "Doctor Who" }
  let (:sword) {
    Weapon.new "The sword of epicness",
      'the best sword in the world!',
      {:damage => 20}}

  it "has a name" do
    player.name.should be_kind_of String
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
    unless player.inventory_full?
      player.pick_up(sword).should be == :pick_up
    end
  end

  it "has stats" do
    player.stats.should be_kind_of Hash
  end

  it "can drop an item" do
    me = Player.new "CodeMonkey"
    me.pick_up sword
    me.drop(sword).should be == :item_dropped
  end

  it "can move around" do
    player.move(:up).should be == :player_moved
    #player.move(5).should be == :unable_to_move
  end


end