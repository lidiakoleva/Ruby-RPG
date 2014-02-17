require "constants.rb"

class Player
  attr_reader :name, :xp, :level, :stats, :inventory, :direction, :x, :y

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

    @direction = :down
    @x = 5
    @y = 5
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

  def drop(item, drop_count = 1)
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
        :already_equipped
      else
        #TODO
      end
    else
      :unable_to_equip
    end
  end

  def move(direction)
    dir_vector = Players::DIRECTIONS[direction]
    if dir_vector.nil? or (@x + dir_vector[0] < 0) or (@y + dir_vector[1] < 0)
      :unable_to_move
    else
      @x += dir_vector[0]
      @y += dir_vector[1]
      @direction = direction

      :player_moved
    end
  end

end