require_relative '../lib/world.rb'
require_relative '../lib/tile.rb'

describe World do
  let(:path) {String.new("/home/latunov/Desktop/ruby_proj/data/levels/1.bmp")}
  let (:world) {World.new(path, "Random Hero")}

  it "has a map" do
    world.should respond_to :map
  end

  it "has a player" do
    world.should respond_to :player
  end

  it "map has tiles" do
    world.map[2][3].should be_kind_of Tile
  end

  it "map has NPCs" do
    world.map.any? {|x| x.any? {|tile| tile.should respond_to :mob}}
  end

end