require 'tile.rb'
require 'player.rb'
require 'npc.rb'

module Colours
  #Note: BMP saves the colours in BGR instead of RGB!
  GREEN = '00c864'.freeze
  GREY = '919191'.freeze
  BLUE = '9b7805'.freeze
  BLACK = '000000'.freeze
  WHITE = 'ffffff'.freeze
end

module Map
  WORLD = {Colours::GREEN => Tile,
           Colours::GREY => Wall,
           Colours::BLUE => Water,
           Colours::BLACK => NPC,
           Colours::WHITE => Player}.freeze

  NPC_STATS = {:name => ['Giant Rat', 'Goo Blob', 'Skeleton', 'Merman', 'Elf'],
               :stats => [{}],
               :xp => [240, 250, 260, 270]}.freeze
end