require "constants.rb"

class Item
  attr_reader :name, :description, :stats, :type
  def initialize(name='', desc='', stats={}, type=Items::CONSUMABLE)
    @name = (name.is_a? String) ? name : "???"
    @description = (desc.is_a? String) ? desc : "IDK LOL"
    @stats = (stats.is_a? Hash) ? stats : {}
    @equipped = false
    @type = type
  end

  def equip
    if @equipped == false
      @equipped = true
      Items::EQUIP
    else
      Items::ALREADY_EQUIPPED
    end
  end

  def == other
    (@name == other.name and @type == other.type and @stats == other.stats)
  end

  def equipped?
    @equipped
  end
end
