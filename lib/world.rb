require 'bmp_reader.rb'
require 'constants.rb'

class World

  attr_reader :map

  def initialize(level, player_name)
    @map = nil
    @player = nil
    create_map(level, player_name)
  end

  private
  def create_map(level, player_name)
    bitmap = BMPReader.new ("../data/levels/#{level}.bmp")
    @map = Array.new(bitmap.height) {Array.new(bitmap.width)}
    (0..bitmap.height).each  do |j|
      (0..bitmap.width).each do |i|

        case bitmap[i,j]
        when Colours::GREEN
          @map[i][j] = Tile.new
        when Colours::GREY
          @map[i][j] = Wall.new
        when Colours::Black
          @map[i][j] = Tile.new(true, NPC.new)
        when Colours::BLUE
          @map[i][j] = Water.new
        when Colours::WHITE
          @map[i][j] = Tile.new
          @player = Player.new(player_name, i, j)
        end
      end
    end
  end

end