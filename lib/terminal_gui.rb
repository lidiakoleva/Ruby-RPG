require_relative 'world.rb'
require 'curses'
require 'yaml/store'

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

    x_offset = (Curses::cols - 2 - @world.width * 2) / 2
    @subwindow = @main_window.subwin(@world.height, (@world.width * 2),
                                       4, x_offset)


    options = ["New Game", "Load Game", "Exit"]

    case render_menu(@main_window, '[Ruby RPG]', options)

    when "New Game"
      render_map(@subwindow)

    when "Load Game"
      load_game
      if @world.nil?
        @run = false
      else
        render_map(@subwindow)
      end
    when "Exit"
      @run = false
    end

    interact
    stop

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

  def add_text(window, text, colouring)
    window.attron(Curses::color_pair(@pairs[colouring]))
    window << text
    window.attroff(Curses::color_pair(@pairs[colouring]))
  end

  def check_map_size
    if Curses::lines < @world.height + 3
      print "Map too large to be loaded!\n"
      print "Lines: #{Curses::lines}\nWorld: #{world.height}\n"
      stop
    end
  end

  def combat(mob)
    top_left_y = (@main_window.maxy * 0.6).round
    combat_menu = @main_window.subwin(@main_window.maxy - top_left_y,
                                  @main_window.maxx.pred.pred,
                                  top_left_y, 1)
    combat_menu.clear
    combat_menu.refresh

    player = @world.player
    question = "What do you wish to do?: "
    combat_options = ["Fight", "Flee in Terror", "Fart in it's face"]

    combat_menu.setpos(1, 2)
    add_text(combat_menu, player.name, "Player Menu")

    combat_menu << ' has encountered '
    combat_menu << ('AEIOU'.include?(mob.name[0]) ? 'an ' : 'a ')

    add_text(combat_menu, mob.name, "Mob Menu")

    combat_menu << "\n"
    combat_menu.setpos(3, 2)
    combat_menu << question
    combat_menu.box('#', '-')


    combat_options.each_with_index do |el, i|
      combat_menu.setpos(5 + i, 2)
      combat_menu << "#{i.succ}. #{el}"
    end
    

    combat_menu.setpos(3, question.size + 2)

    combat_menu.refresh
    choice = combat_menu.getch

    case combat_options[choice.to_i.pred]

    when "Fight"
      fight(mob, player, combat_menu) unless player.dead? or mob.dead?
      if player.dead?
        stop
      else
        player.end_combat
        @world.kill_mob(mob)
      end
    when "Flee in Terror"
      #idk
    when "Fart in it's face"
      mob.recieve_damage(player)
    end

    combat_menu.close
  end

  def fight(mob, player, window)

    window.setpos(2, window.maxx / 2)
    window << "You deal "
    add_text(window, mob.recieve_damage(player).to_s, "Title")
    window << " damage to #{mob.name}"

    window.setpos(3, window.maxx / 2)
    window << "#{mob.name} deals "
    add_text(window, player.recieve_damage(mob).to_s, "Mob Menu")
    window << " to you"
    window.refresh
    window.getch

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

    @pairs = {"Title" => 1, "Tile" => 2, "Water" => 3, "Wall" => 4,
              "Player" => 5, "Mob Menu" => 6, "Player Menu" => 7}

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

    while @run
      key = @subwindow.getch

      case key

      when keys::F10

        options = ["Resume", "Save", "Exit"]

        case render_menu(@main_window, "Menu", options)

        when "Resume"
          render_map(@subwindow)
        when "Save"
          save_game
          render_map(@subwindow)
        when "Exit"
          @run = false
        end

      when 27

        @run = false

      when keys::UP, keys::DOWN, keys::LEFT, keys::RIGHT

        move_player(@directions[key], @subwindow)
      end
      
      @main_window.box('#', '-')
      @main_window.refresh
    end
  end

  def load_game
    saved_game = YAML::Store.new("data/saves/#{@player_name}.store")
    saved_game.transaction do
      @world = saved_game[@player_name]
    end
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

  def render_menu(window, title, options)
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

  def save_game
    save_file = YAML::Store.new("data/saves/#{@player_name}.store")
    save_file.transaction do
      save_file[@player_name] = @world
    end
  end

  def stop
    @subwindow.close unless @subwindow.nil?
    @main_window.close unless @main_window.nil?
    Curses::close_screen
  end

end
