require_relative 'item.rb'

class Chest < Tile

  attr_reader :items

  def initialize(items, mob)
    super(true, mob)
    @items = items
  end

  def empty?
    @item.empty?
  end

end