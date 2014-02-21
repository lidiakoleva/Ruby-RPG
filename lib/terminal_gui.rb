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
    initialize_world

    options = ["New Game", "Load Game", "Exit"]
    player_choice = render_main_menu(@main_window, '[Ruby RPG]', options)


    case player_choice

    when "New Game", "Load Game"
      x_offset = (Curses::cols - 2 - @world.width * 2) / 2
      @subwindow = @main_window.subwin(@world.height, (@world.width * 2),
                                       4, x_offset)
      render_map(@subwindow)
      interact
    when "Exit"
      stop
    end


  end

  private #---serious business starts here---#

  def add_titles(heading_1, heading_2)
    @main_window.attron(Curses::color_pair(@pairs["Title"]))

    @main_window.setpos(2, (Curses::cols.pred - heading_1.size - 2) / 2)
    @main_window << heading_1

    @main_window.setpos(3, (Curses::cols.pred - heading_2.size - 2) / 2)
    @main_window << heading_2

    @main_window.attroff(Curses::color_pair(@pairs["Title"]))
    @main_window.refresh
  end

  def check_map_size
    if Curses::lines < @world.height + 3
      print "Map too large to be loaded!\n"
      print "Lines: #{Curses::lines}\nWorld: #{world.height}\n"
      stop
    end
  end

  def combat(mob)
    make_combat_menu
    player = @world.player

    @menu.attron(Curses::color_pair(@pairs["Player Menu"]))
    @menu << player.name
    @menu.attroff(Curses::color_pair(@pairs["Player Menu"]))

    @menu << ' has encountered '
    @menu << ('AEIOU'.include?(mob.name[0]) ? 'an ' : 'a ')

    @menu.attron(Curses::color_pair(@pairs["Mob Menu"]))
    @menu << mob.name
    @menu.attroff(Curses::color_pair(@pairs["Mob Menu"]))
    @menu << "\n"
    @menu.setpos(3, 2)
    @menu << "What do you wish to do?\n"
    @menu.box('#', '-')


    ["Fight", "Flee in Terror", "Fart in it's face"].each_with_index do |el, i|
      @menu.setpos(5 + i, 2)
      @menu << "#{i.succ}. #{el}"
    end
      @menu.setpos(5, 2)



    @menu.refresh(0, 0,
                  Curses::lines * 0.6, 2,
                  Curses::lines - 1, Curses::cols - 2)
    @menu.getch
    @menu.close
  end

  def initialize_color_pairs
    Curses::start_color
    Curses::init_pair(1, Curses::COLOR_GREEN, Curses::COLOR_BLACK)
    Curses::init_pair(2, Curses::COLOR_GREEN, Curses::COLOR_GREEN)
    Curses::init_pair(3, Curses::COLOR_BLUE, Curses::COLOR_BLUE)
    Curses::init_pair(4, Curses::COLOR_WHITE, Curses::COLOR_WHITE)
    Curses::init_pair(5, Curses::COLOR_BLUE, Curses::COLOR_GREEN)
    Curses::init_pair(6, Curses::COLOR_RED, Curses::COLOR_BLACK)
    Curses::init_pair(7, Curses::COLOR_BLUE, Curses::COLOR_BLACK)
  end

  def initialize_world
    Curses.init_screen

    check_map_size

    heading_1 = "Welcome, #{@player_name} to"
    heading_2 = "The best RPG EVER!"

    initialize_color_pairs

    @pairs = {"Title" => 1, "Tile" => 2, "Water" => 3,
              "Wall" => 4, "Player" => 5, "Mob Menu" => 6, "Player Menu" => 7}

    make_main_window

    add_titles(heading_1, heading_2)
  end

  def inside_world?(x, y)
    0.upto(@world.width.pred).include? x and
    0.upto(@world.height.pred).include? y
  end

  def interact
    Curses.noecho
    @subwindow.keypad(true)

    keys = Curses::Key
    @directions = {keys::UP => :up, keys::DOWN => :down,
                   keys::LEFT => :left, keys::RIGHT => :right}

    loop do
      key = @subwindow.getch
      break if [27, Curses::Key::F10].include? key
      if @directions.include? key
        move_player(@directions[key], @subwindow)
      end
      @main_window.box('#', '-')
      @main_window.refresh
    end
  end

  def make_combat_menu(x = Curses::cols - 4,
                y = (Curses::lines * 0.4).round,
                padding = 2)
    @menu = Curses::Pad.new(y, x)
    @menu.box('#', '-')
    @menu.setpos(padding, padding)
  end

  def make_main_window
    @main_window = Curses::Window.new(0, 0, 0, 0)
    @main_window.box('#', '-')
    @main_window.refresh
  end

  def move_player(direction, window)
    x, y = @world.player.x, @world.player.y

    dir_vector = @world.player.directions(direction)
    x_next, y_next = x + dir_vector[0], y + dir_vector[1]

    if inside_world?(x_next, y_next) and
      @world[x_next, y_next].instance_of? Tile
      
      if @world[x_next, y_next].has_mob?
        combat(@world[x_next, y_next].mob)
        @main_window.clear
        render_map(@subwindow)
      end

      @world.player.move(direction)
      render_pixel(window, x, y, "Tile")
      render_pixel(window, x_next, y_next, "Player")
    end
  end

  def render_main_menu(window, title, options)
    longest_word = options.group_by(&:size).max.last[0].size
    
    window.clear
    window.box('#', '-')
    
    width = (longest_word + 9 < 26 ? 26 : longest_word + 9)
    height = options.size + 5
    x_center = (window.maxx - width - 2) / 2
    y_center = (window.maxy - height - 2) / 2

    menu = window.subwin(height, width, y_center, x_center)

    options.each_with_index do |elem, index|
      menu.setpos(2 + index, 3)
      menu << "#{index.succ}. #{elem}"
    end

    menu.box('#', '-')
    Curses.noecho

    menu.setpos(0, (menu.maxx - title.size) / 2)
    menu << title

    menu.setpos(3 + options.size, 3)
    menu << "Enter your choice: "
    choice = menu.getch

    while options[choice.to_i.pred].nil? or choice.to_i < 1
      choice = menu.getch
    end

    menu.close
    Curses.echo
    options[choice.to_i.pred]
  end

  def render_map(window)
    0.upto(@world.height.pred).each do |j|
      0.upto(@world.width.pred).each do |i|
        
        tile_type = @world[i, j].class.to_s
        render_pixel(window, i, j, tile_type)

      end
    end
    render_pixel(window, @world.player.x, @world.player.y, "Player")
    window.refresh
  end

  def render_pixel(window, x, y, pixel_type)
    window.setpos(y, x * 2)
    window.attron(Curses::color_pair(@pairs[pixel_type]))
    window << @render_palette[pixel_type]
    window.attroff(Curses::color_pair(@pairs[pixel_type]))
  end

  def stop
    @subwindow.close unless @subwindow.nil?
    @main_window.close unless @main_window.nil?
    Curses::close_screen
  end

end
