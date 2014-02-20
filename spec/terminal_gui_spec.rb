require_relative '../lib/terminal_gui.rb'

describe TerminalGUI do
  let(:terminal) {TerminalGUI.new("../data/levels/1.bmp")}
  it "can be started" do
    terminal.should respond_to :start
  end
end