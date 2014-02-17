require_relative '../lib/world.rb'
require_relative '../lib/tile.rb'

describe World do
  let (:world) {World.new(1)}

  it "has a map" do
    pending
    world.should respond_to :map
  end

  it "has a player" do
    pending
    world.should respond_to :player
  end

  it "has tiles" do
    pending
    world.tile(1, 1).should be_kind_of Tile
  end

  it "has NPCs" do
    pending
    world.npc?(1, 1).should be_kind_of Boolean
  end

end