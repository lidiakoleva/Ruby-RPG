require_relative 'world.rb'
require 'curses'

class TerminalGUI

  @@render_palette = {"Tile" => '^^', "Water" => '~~', "Wall" => '##'}

  def initialize(lvl_path,
                 render_palette = {},
                 world_palette = nil,
                 npc_palette = nil)
    @player_name = nil
    @world = nil
    @main_window = nil
    @subwindow = nil
    @quit = false

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
  end

  def move_player(direction)
  end

  def stop
    @subwindow.close unless @subwindow.nil?
    @main_window.close unless @main_window.nil?
  end

  def render_world
    
  end

end