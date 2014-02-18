require 'bmp_reader.rb'
require 'constants.rb'
require 'tile.rb'

class World

  attr_reader :map, :player

  def initialize(level, player_name)
    @map = []
    @player = nil
    create_map(level, player_name)
  end

  private

  def create_map(level, player_name)
    bitmap = BMPReader.new(level)

    @map = Array.new(bitmap.height) { [] }

    (0...bitmap.height).each  do |i|
      (0...bitmap.width).each do |j|

        case bitmap[j, i]
        when Colours::GREEN
          @map[i] << Tile.new
        when Colours::GREY
          @map[i] << Wall.new
        when Colours::BLACK
          @map[i] << Tile.new(true, NPC.new("Some name", {}, 400))
        when Colours::BLUE
          @map[i] << Water.new
        when Colours::WHITE
          @map[i] << Tile.new
          @player = Player.new(player_name, i, j)
        end
      end
    end
  end

end