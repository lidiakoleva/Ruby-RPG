require_relative '../lib/npc.rb'

describe NPC do
  let(:npc) {NPC.new ("Cookie Monster")}

  context "basic stats" do
    it "has a name" do
      npc.should respond_to :name
    end

    it "has stats" do
      npc.should respond_to :stats
    end

    it "has experience and items that it can give off (upon death)" do
      npc.loot[:xp].should be >= 0
      npc.loot[:item].should be_kind_of Item unless npc.loot[:item].nil?
    end
  end

  it "has a chance to drop an item"

  it "gives off experience when it dies (based on it's own)"

end