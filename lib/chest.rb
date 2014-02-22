require_relative 'item.rb'

class Chest

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def empty?
    @item.empty?
  end

end