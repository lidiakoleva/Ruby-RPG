require_relative 'bmp_reader.rb'
require_relative 'tile.rb'
require_relative 'npc.rb'
require_relative 'player.rb'

class World

  module Map
    WORLD = {Colours::GREEN => Tile,
             Colours::GREY => Wall,
             Colours::BLUE => Water,
             Colours::BLACK => NPC,
             Colours::WHITE => Player}.freeze

    NPC_STATS = {:name => ['Rat', 'Goo Blob', 'Skeleton', 'Merfolk', 'Elf'],
                 :stats => [{}],
                 :xp => [240, 250, 260, 270]}.freeze
  end

  attr_reader :map, :player

  def initialize(level,
                 player_name,
                 world_palette = Map::WORLD,
                 npc_palette = Map::NPC_STATS)
    @map = []
    @player = nil
    @world_palette = world_palette.dup
    @npc_palette = npc_palette.dup

    create_map(level, player_name)
  end

  def [](x, y)
    @map[y][x]
  end

  def []=(x, y, other)
    @map[y][x] = other
  end

  private

  def npc_stats
    [@npc_palette[:name].sample,
     @npc_palette[:stats].sample,
     @npc_palette[:xp].sample]
   end

  def create_map(level, player_name)
    begin
      bitmap = BMPReader.new(level)
    rescue
      puts "BMP Reader unable to read #{level}"
    end


    @map = Array.new(bitmap.height) { [] }

    (0...bitmap.height).each  do |i|
      (0...bitmap.width).each do |j|

        case @world_palette[bitmap[j, i]].name

        when "Tile", "Wall", "Water"
          @map[i] << @world_palette[bitmap[j, i]].new

        when "NPC"
          @map[i] << Tile.new(true, NPC.new(*npc_stats))

        when "Player"
          @map[i] << Tile.new
          @player = Player.new(player_name, j, i)

        end
      end
    end
  end

end