require "constants.rb"

class Player
  attr_reader :name, :xp, :level, :stats, :inventory

  def initialize(name)
    @name = name || "Unknown Warrior"
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

  def inventory_full?
    @load == Players::MAX_LOAD
  end

  def pick_up(item)

    if inventory_full?

      :inventory_full
    else

      if item.is_a? Consumable and @inventory.include? item
        @inventory[@inventory.index(item)].add
      else
        @inventory << item
        @load += 1

        :pick_up
      end

    end
  end

  def drop(item, drop_count)
    if @inventory.include? item

      if item.is_a? Consumable

        item_in_inventory = @inventory[@inventory.index(item)]
        item_in_inventory.drop(drop_count)

        @inventory.reject! { |x| x.eql? item } if item_in_inventory.empty?
      else
        @inventory.reject! { |x| x.eql? item } # Non-stackable item
      end

      :item_dropped
    else

      :unable_to_drop
    end
  end

  def equip(item, position)
    if @inventory.include? item
      if item.equipped?
        return :already_equipped
      else
        item.equip
      end
    else
      :unable_to_equip
    end
  end

end