class NPC
  attr_reader :name, :stats, :xp
  def initialize(name, stats = {}, xp = 100)
    @name = name
    @stats = stats
    @xp = xp
  end

  def kill
    stats[:current_hp] = 0
    @xp
  end

end