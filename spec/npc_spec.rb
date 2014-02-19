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

    it "has experience that it can give off (upon death)" do
      npc.kill.should be_kind_of Integer
    end
  end

  it "can die" do
    npc.should respond_to :kill
  end

end