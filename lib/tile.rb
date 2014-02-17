require_relative 'npc.rb'

class Tile

  attr_reader :x, :y

  def initialize(x, y, pass_through)
    @x = x
    @y = y
    @pass_through = pass_through
  end

  def pass_through?
    @pass_through
  end

end