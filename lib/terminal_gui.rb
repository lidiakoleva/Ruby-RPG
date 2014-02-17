class TerminalGUI
  @@end_coloring = "\033[0m"

  def initialize(palette)
    @palette = palette
  end

  def color(text, color)
    col = @palette[color.to_sym]
    "#{col}#{text}#{@@end_coloring}"
  end
end