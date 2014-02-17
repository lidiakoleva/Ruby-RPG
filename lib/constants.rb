module Players
  BASIC_STATS = {:hp => 80, :armor => 0, :damage => 12, :mana => 60}
  MAX_LOAD = 25

  DIRECTIONS = {:up => [0, 1], :down => [0, -1],
                :left => [-1, 0], :right => [1, 0]}
end

module Colors
  GREEN = '00c864'.freeze
  GREY = '919191'.freeze
  BLUE = '9b7805'.freeze
end