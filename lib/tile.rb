class Tile
  attr_reader :mob
  def initialize(pass_through = true, mob = nil, chest = nil)
    @pass_through = pass_through
    @mob = mob
    @chest = chest
  end

  def has_mob?
    @mob != nil
  end

  def kill_mob
    @mob = nil
  end

  def pass_through?
    @pass_through
  end
end

class Wall < Tile
  def initialize
    super(false, nil)
  end
end

class Water < Tile
  def initialize
    super(false, nil)
  end
end