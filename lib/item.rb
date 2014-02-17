require "constants.rb"

class Item
  attr_reader :name, :description, :stats

  def initialize(name, description, stats)
    @name = name || "Unknown item"
    @description = description || ''
    @stats = stats || {}
  end

  def ==(other)
    (@name == other.name and @stats == other.stats)
  end
end


class Consumable < Item
  attr_reader :name, :description, :stats, :stack

  def initialize(name, description, stats, stack)
    super(name, description, stats)
    @stack = stack
  end

  def add
    @stack += 1
  end

  def drop(count = 1)
    @stack -= count
  end

  def empty?
    @stack < 1
  end

  def equip(position)
    #TODO -- not sure if needed
  end

end

class Armor < Item
  attr_reader :name, :description, :stats
  def initialize(name, description, stats)
    super(name, description, stats)
  end
end

class Weapon < Item
  attr_reader :name, :description, :stats

  def initialize(name, description, stats)
    super(name, description, stats)
  end
end

