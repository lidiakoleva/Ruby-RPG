require "constants.rb"

class Item
  attr_reader :name, :description, :stats

  def initialize(name='', desc='', stats={}, type=CONSUMABLE, player)
    @name = name if name.is_a String
    @description = desc if desc.is_a String
    @stats = stats if stats.is_a Hash
    @equipped = false
    @type = type
    @player = player
  end

  def equip
   if type == CONSUMABLE
     @player.use self
     #TODO
   end
  end
end
