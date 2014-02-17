require_relative 'bmp_reader.rb'

class World

  attr_reader :map

  def initialize(map)
    @map = create_map(map)
  end

  private
  def create_map(level)
    bitmap = BMPReader.new ("../data/levels/#{level}.bmp")
    #TODO
  end

end