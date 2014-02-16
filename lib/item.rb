require "constants.rb"

class Item
  attr_reader :name, :description, :stats, :type
  def initialize(name='', desc='', stats={}, type=:consumable)
    @name = (name.is_a? String) ? name : "???"
    @description = (desc.is_a? String) ? desc : "IDK LOL"
    @stats = (stats.is_a? Hash) ? stats : {}
    @equipped = false
    @type = type
  end

  def equip
    if @equipped == false
      @equipped = true
      :equip
    else
      :already_equipped
    end
  end

  def == other
    (@name == other.name and @type == other.type and @stats == other.stats)
  end

  def equipped?
    @equipped
  end
end
