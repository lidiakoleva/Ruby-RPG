require "constants.rb"

class Player
  attr_reader :name, :xp, :level, :stats, :inventory,
              :direction, :x, :y, :load, :basic_stats

  def initialize(name, x = 5, y = 5)
    #---init stats---
    @name = name || "Unknown Warrior"
    @xp = 0
    @level = 1
    @basic_stats = BASIC_STATS.dup
    @max_hp = @basic_stats[:hp]
    @max_mana = @basic_stats[:mana]

    #---combat related stats---
    @stats = BASIC_STATS.dup
    @current_hp = @stats[:hp]
    @current_mana = @stats[:mana]

    @inventory = []
    @equipped_items = NO_ITEMS_EQUIPPED.dup
    @load = 0
    #---world related stats---
    @direction = :down
    @x = x
    @y = y
  end

  def hp
    [@current_hp, @max_hp]
  end

  def inventory_full?
    @load == MAX_LOAD
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
      end

      :picked_up
    end
  end

  def drop(item, drop_count = 1)
    if @inventory.include? item

      if item.is_a? Consumable

        item_in_inventory = @inventory[@inventory.index(item)]
        item_in_inventory.drop(drop_count)

        @inventory.reject! { |x| x.eql? item } if item_in_inventory.empty?
      else
        @equipped_items.each { |key, value| unequip(key) if value == item}
        @inventory.reject! { |x| x.eql? item } # Non-stackable item
      end
      @load -= 1

      :item_dropped
    else

      :unable_to_drop
    end
  end

  def unequip(position)
    @equipped_items[position] = nil
    update_stats
  end

  def equip(item, position)
    if @inventory.include? item and item.equippable_on?(position)
      if @equipped_items[position] == item
        :already_equipped
      else
        unequip(position)
        @equipped_items[position] = item
        update_stats

        :item_equipped
      end
    else
      :unable_to_equip
    end
  end

  def move(direction)
    dir_vector = DIRECTIONS[direction]

    @x += dir_vector[0]
    @y += dir_vector[1]
    @direction = direction

    :player_moved
  end

  private

  def update_stats
    @stats = @basic_stats.dup
    @equipped_items.each do |key, item|
      puts item
      unless item.nil?
        @stats.merge!(item.stats) {|key, val1, val2| val1 + val2}
      end
    end
  end

  MAX_LOAD = 20
  DIRECTIONS = {:up => [0, -1], :down => [0, 1],
                :left => [-1, 0], :right => [1, 0]}.freeze

  NO_ITEMS_EQUIPPED = {:left_hand => nil, :right_hand => nil, :head => nil, 
                       :torso => nil,     :legs => nil,       :feet => nil}
  BASIC_STATS = {:hp => 80, :armour => 0, :damage => 12, :mana => 40}.freeze

end