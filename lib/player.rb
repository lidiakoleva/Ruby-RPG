require "constants.rb"

class Player
  attr_reader :name, :xp, :level, :stats, :inventory

  def initialize(name)
    @name = name.is_a?(String) ? name : "Unknown warrior"
    @xp = 0
    @level = 1
    @stats = Players::BASIC_STATS
    @current_hp = stats[:hp]
    @max_hp = stats[:hp]
    @current_mana = stats[:mana]
    @inventory = []
    @load = 0
  end

  def hp
    "#{@current_hp / @max_hp}"
  end

  def max_load?
    @load == Players::MAX_LOAD
  end

  def pick_up item
    if not max_load? and item.kind_of? Item
      @inventory << item
      @load += 1
      Items::PICK_UP
    else
      Items::UNABLE_TO_PICK_UP
    end
  end

  def equip item
    if @inventory.include? item
      if item.equipped?
        return Items::ALREADY_EQUIPPED
      else
        item.equip
      end
    else
      Items::UNABLE_TO_EQUIP
    end
  end

end