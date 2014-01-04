module Items
  EQUIP = true
  UNEQUIP = false
  ALREADY_EQUIPPED = 1
  UNABLE_TO_EQUIP = 2
  CONSUMABLE = 100
  HELMET = 200
  WEAPON = 201
  SHILED = 202
  ARMOUR = 203
  BOOTS  = 204
  PICK_UP = 300
end

module Players
  BASIC_STATS = {
    :hp => 80,
    :armor => 0,
    :damage => 12,
    :mana => 60
  }
  MAX_LOAD = 25
end