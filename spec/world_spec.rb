require_relative '../lib/world.rb'
require_relative '../lib/tile.rb'

describe World do
  let(:path) {String.new("data/levels/1.bmp")}
  let (:world) {World.new(path, "Random Hero")}

  it "can be initialized" do
    w = World.new(path, "name")
    w.should be_kind_of World
  end

  it "has a map" do
    world.should respond_to :map
  end

  it "has a player" do
    world.should respond_to :player
  end

  it "map has tiles" do
    world = World.new("data/levels/1.bmp", "")
    world[0, 0].should be_kind_of Tile
  end

  it "map has NPCs" do
    world.map.any? {|x| x.any? {|tile| tile.should respond_to :mob}}
  end

  it "cannot be initiated without a player" do
    mobs_only_map = "data/levels/no_player.bmp"
    expect {World.new(mobs_only_map, "")}.to raise_error World::NoPlayerError
  end

  it "raises an error if it cannot load the map" do
    fake_map = "data/levels/omgwtfbbq.bmp"
    expect {World.new(fake_map, "")}.to raise_error World::UnableToReadImage
  end

end
