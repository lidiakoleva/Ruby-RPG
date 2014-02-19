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
  attr_reader :stack

  def initialize(name, description, stats, stack = 1)
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
end

class Equippable < Item

  def initialize(name, description, stats, equippable_on)
    super(name, description, stats)
    @equippable_on = equippable_on.dup
  end

  def ==(other)
    self.eql? other
  end

  def equippable_on?(position)
    @equippable_on.include? position
  end
end

class Weapon < Equippable
  def initialize(name, description, stats)
    super(name, description, stats, [:right_hand, :left_hand])
  end
end

class Armour < Equippable
  def initialize(name, description, stats)
    super(name, description, stats, [:torso])
  end
end

class Pants < Equippable
  def initialize(name, description, stats)
    super(name, description, stats,[:legs])
  end
end

class Boots < Equippable
  def initialize(name, description, stats)
    super(name, description, stats,[:feet])
  end
end

class Helmet < Equippable
  def initialize(name, description, stats)
    super(name, description, stats,[:head])
  end
end