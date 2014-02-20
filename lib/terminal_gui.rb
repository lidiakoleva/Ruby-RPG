require_relative 'world.rb'
require 'curses'

class TerminalGUI

  @@render_palette = {"Tile" => '^^', "Water" => '~~',
                      "Wall" => '##', "Player" => '☺ '}

  def initialize(lvl_path,
                 render_palette = {},
                 world_palette = nil,
                 npc_palette = nil)
    @player_name = nil
    @world = nil
    @main_window = nil
    @subwindow = nil
    @run = true

    @render_palette = render_palette.merge @@render_palette
    @lvl_path = lvl_path
    @world_palette = world_palette
    @npc_palette = npc_palette
  end

  def start
    system 'reset'
    print 'Enter your name: '
    @player_name = gets.chomp
    @world = World.new(@lvl_path, @player_name, @world_palette, @npc_palette)
    render_world
    interact
  end

  private

  def interact
    Curses.noecho
    @subwindow.keypad(true)

    keys = Curses::Key
    @directions = {keys::UP => :up, keys::DOWN => :down,
                   keys::LEFT => :left, keys::RIGHT => :right}

    loop do
      key = @subwindow.getch
      break if key.equal?(27)
      if @directions.include? key
        move_player(@directions[key], @subwindow)
      end
      @main_window.refresh
    end
  end

  def inside_world?(x, y)
    0.upto(@world.width.pred).include? x and
    0.upto(@world.height.pred).include? y
  end

  def render_player(window, pair)
    window.setpos(@world.player.y, @world.player.x * 2)
    window.attron(Curses::color_pair(pair["Player"]))
    window << @render_palette["Player"]
    window.attroff(Curses::color_pair(pair["Player"]))
    window.refresh
  end

  def render_pixel(window, x, y, pixel_type)
    window.setpos(y, x * 2)
    window.attron(Curses::color_pair(@pairs[pixel_type]))
    window << @render_palette[pixel_type]
    window.attroff(Curses::color_pair(@pairs[pixel_type]))
  end

  def check_map_size
    if Curses::lines < @world.height + 3
      print "Map too large to be loaded!\n"
      print "Lines: #{Curses::lines}\nWorld: #{world.height}\n"
      stop
    end
  end

  def move_player(direction, window)
    x, y = @world.player.x, @world.player.y

    dir_vector = @world.player.directions(direction)
    x_next, y_next = x + dir_vector[0], y + dir_vector[1]

    if inside_world?(x_next, y_next) and
      @world[x_next, y_next].instance_of? Tile
      @world.player.move(direction)

      render_pixel(window, x, y, "Tile")
      render_pixel(window, x_next, y_next, "Player")
    end
  end

  def initialize_color_pairs
    Curses::start_color
    Curses::init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses::init_pair(2, Curses::COLOR_GREEN, Curses::COLOR_GREEN)
    Curses::init_pair(3, Curses::COLOR_BLUE, Curses::COLOR_BLUE)
    Curses::init_pair(4, Curses::COLOR_WHITE, Curses::COLOR_WHITE)
    Curses::init_pair(5, Curses::COLOR_BLUE, Curses::COLOR_GREEN)
  end

  def add_titles(heading_1, heading_2)
    @main_window.attron(Curses::color_pair(@pairs["Title"]))

    @main_window.setpos(2, (Curses::cols.pred - heading_1.size - 2) / 2)
    @main_window << heading_1

    @main_window.setpos(3, (Curses::cols.pred - heading_2.size - 2) / 2)
    @main_window << heading_2

    @main_window.attroff(Curses::color_pair(@pairs["Title"]))
    @main_window.refresh
  end

  def stop
    @subwindow.close unless @subwindow.nil?
    @main_window.close unless @main_window.nil?
    Curses::close_screen
  end

  def render_world
    Curses.init_screen

    check_map_size

    heading_1 = "Welcome, #{@player_name} to"
    heading_2 = "The best RPG EVER!"

    initialize_color_pairs

    @pairs = {"Title" => 1, "Tile" => 2,
              "Water" => 3, "Wall" => 4, "Player" => 5}

    @main_window = Curses::Window.new(0, 0, 0, 0)
    @main_window.box('#', '-')
    @main_window.refresh

    add_titles(heading_1, heading_2)

    @subwindow = @main_window.subwin(@world.height, (@world.width * 2), 4,
                                     (Curses::cols - 2 - @world.width * 2) / 2)

    0.upto(@world.height.pred).each do |j|
      0.upto(@world.width.pred).each do |i|
        
        tile_type = @world[i, j].class.to_s
        render_pixel(@subwindow, i, j, tile_type)

      end
    end
    render_pixel(@subwindow, @world.player.x, @world.player.y, "Player")

    @subwindow.refresh
    @main_window.refresh
  end

end