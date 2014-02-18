require_relative "../lib/player.rb"
require_relative "../lib/item.rb"

describe Player do
  let (:player) { Player.new "Doctor Who" }
  let (:sword) {
    Weapon.new "The sword of epicness",
      'the best sword in the world!',
      {:damage => 20}}

  context "basic information" do

    it "has a name" do
      player.name.should be_kind_of String
    end

    it "has experience" do
      player.should respond_to :xp
    end

    it "has a level" do
      player.should respond_to :level
    end

    it "has stats" do
      player.stats.should be_kind_of Hash
    end
  end

  context "can interact with items" do

    it "has items" do
      player.should respond_to :inventory
    end

    it "picks up items (if the inventory is not full)" do
      hero = Player.new("Some Name")
      armour_arr = [Armour.new('Platemail', '', {:armour => 4})] * 25
      #Note: The maximum inventory size of any hero is 25
      armour_arr.each {|item| hero.pick_up(item)}
      hero.pick_up(sword).should be == :inventory_full
    end

    it "drops an item (if he has it in his inventory)" do
      me = Player.new "CodeMonkey"
      me.pick_up(sword)
      me.drop(sword).should be == :item_dropped
      me.load.should be == 0
      me.drop(sword).should be == :unable_to_drop
    end
  end

  context "can interact with mobs:" do
    it "fights monsters"

    it "dies"

    it "levels up"

    it "gains experience"
  end

  it "can move around (if it is not the end of the map)" do
    5.times {player.move(:up).should be == :player_moved}
    #Note: the default spawning position is [5,5] 
    #      and [0,0] is the top-left corner of the screen
    player.move(:up).should be == :unable_to_move
  end

end