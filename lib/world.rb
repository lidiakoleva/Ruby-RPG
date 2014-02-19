require 'bmp_reader.rb'
require 'constants.rb'
require 'tile.rb'

class World

  attr_reader :map, :player

  def initialize(level,
                 player_name,
                 world_palette = Map::WORLD,
                 npc_palette = Map::NPC_STATS)
    @map = []
    @player = nil
    @world_palette = world_palette
    @npc_palette = npc_palette

    create_map(level, player_name)
  end

  private

  def npc_stats
    [@npc_palette[:name].sample,
     @npc_palette[:stats].sample,
     @npc_palette[:xp].sample]
   end

  def create_map(level, player_name)
    bitmap = BMPReader.new(level)

    @map = Array.new(bitmap.height) { [] }

    (0...bitmap.height).each  do |i|
      (0...bitmap.width).each do |j|
        case @world_palette[bitmap[j, i]]

        when Tile, Wall, Water
          @map[i] << @world_palette[bitmap[j, i]].new

        when NPC
          @map[i] << Tile.new(true, NPC.new(*npc_stats))

        when Player
          @map[i] << Tile.new
          @player = Player.new(player_name)

        end
      end
    end
  end

end