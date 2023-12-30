require "./08"
RSpec.describe Day08 do
  describe Day08::Node do
    context "initialization" do
      it "has an address" do
        node = Day08::Node.new("AAA")
        expect(node.address).to eq "AAA"
      end

      it "left and right are nil by default" do
        node = Day08::Node.new("AAA")
        expect(node.left).to eq nil
        expect(node.right).to eq nil
      end

      it "can have a left and right defined" do
        node = Day08::Node.new("AAA")
        node.left = "BBB"
        node.right = "CCC"
        expect(node.left).to eq "BBB"
        expect(node.right).to eq "CCC"
      end

      it "can be created from a string" do
        node = Day08::Node.from_string("AAA = (BBB, CCC)")
        expect(node.address).to eq "AAA"
        expect(node.left).to eq "BBB"
        expect(node.right).to eq "CCC"
      end

      it "can be created from a string even if it has numbers" do
        node = Day08::Node.from_string("11A = (11B, XXX)")
        expect(node.address).to eq "11A"
        expect(node.left).to eq "11B"
        expect(node.right).to eq "XXX"
      end
    end

    context "equality" do
      it "is equal to another node with the same address" do
        node1 = Day08::Node.new("AAA")
        node2 = Day08::Node.new("AAA")
        expect(node1).to eq node2
      end

      it "is not equal to another node with a different address" do
        node1 = Day08::Node.new("AAA")
        node2 = Day08::Node.new("BBB")
        expect(node1).not_to eq node2
      end
    end

    it "is a starting_node if it ends in A" do
      node = Day08::Node.new("AAA")
      expect(node.starting_node?).to eq true
    end
    it "is not a strating_node if it does not end in A" do
      node = Day08::Node.new("BBB")
      expect(node.starting_node?).to eq false
    end

    it "is an ending_node if it ends in Z" do
      node = Day08::Node.new("ZZZ")
      expect(node.ending_node?).to eq true
    end

    it "is not an ending_node if it does not end in Z" do
      node = Day08::Node.new("BBB")
      expect(node.ending_node?).to eq false
    end
  end

  describe "Day08::Map" do
    it "has instructions" do
      map = Day08::Map.new("RL")
      expect(map.instructions).to eq "RL"
    end

    it "has a node mapping" do
      map = Day08::Map.new("RL", nodes: [Day08::Node.new("AAA")])
      expect(map.node_mapping).to eq({"AAA" => Day08::Node.new("AAA")})
    end

    it "can be created from an array of strings" do
      input = ["LLR",
        "",
        "AAA = (BBB, BBB)",
        "BBB = (AAA, ZZZ)",
        "ZZZ = (ZZZ, ZZZ)"]
      map = Day08::Map.from_array(input)
      expect(map.instructions).to eq "LLR"
      expect(map.node_mapping).to eq({
        "AAA" => Day08::Node.new("AAA", "BBB", "BBB"),
        "BBB" => Day08::Node.new("BBB", "AAA", "ZZZ"),
        "ZZZ" => Day08::Node.new("ZZZ", "ZZZ", "ZZZ")
      })
    end

    describe "#walk" do
      it "returns the number of steps from start to end" do
        input = ["RL",
          "",
          "AAA = (BBB, CCC)",
          "BBB = (DDD, EEE)",
          "CCC = (ZZZ, GGG)",
          "DDD = (DDD, DDD)",
          "EEE = (EEE, EEE)",
          "GGG = (GGG, GGG)",
          "ZZZ = (ZZZ, ZZZ)"]
        map = Day08::Map.from_array(input)
        expect(map.walk).to eq 2
      end
    end

    describe "#ghost_walk" do
      it "returns the number of steps from all starts to all ends" do
        input = [
          "LR",
          "",
          "11A = (11B, XXX)",
          "11B = (XXX, 11Z)",
          "11Z = (11B, XXX)",
          "22A = (22B, XXX)",
          "22B = (22C, 22C)",
          "22C = (22Z, 22Z)",
          "22Z = (22B, 22B)",
          "XXX = (XXX, XXX)"
        ]
        map = Day08::Map.from_array(input)
        expect(map.ghost_walk).to eq 6
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/08.txt", chomp: true)
      expect(Day08.part_one(input)).to eq 6
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = [
        "LR",
        "",
        "11A = (11B, XXX)",
        "11B = (XXX, 11Z)",
        "11Z = (11B, XXX)",
        "22A = (22B, XXX)",
        "22B = (22C, 22C)",
        "22C = (22Z, 22Z)",
        "22Z = (22B, 22B)",
        "XXX = (XXX, XXX)"
      ]
      expect(Day08.part_two(input)).to eq 6
    end
  end
end
