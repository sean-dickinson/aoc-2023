module Day08
  class Node
    class << self
      def from_string(string)
        address, children = string.split(" = ")
        left, right = parse_children(children)
        new(address, left, right)
      end

      private

      def parse_children(children)
        captures = children.match(/\((?<left>[A-Z]{3}), (?<right>[A-Z]{3})\)/)
        [captures[:left], captures[:right]]
      end
    end

    include Comparable
    attr_reader :address
    attr_accessor :left, :right

    def initialize(address, left = nil, right = nil)
      @address = address
      @left = left
      @right = right
    end

    def <=>(other)
      address <=> other.address
    end
  end

  class Map
    class << self
      def from_array(array)
        instructions = array.shift
        array.shift # blank line
        nodes = array.map { |string| Node.from_string(string) }
        new(instructions, nodes: nodes)
      end
    end

    attr_reader :instructions
    attr_accessor :node_mapping

    START_ADDRESS = "AAA"
    END_ADDRESS = "ZZZ"

    def initialize(instructions, nodes: [])
      @instructions = instructions
      @node_mapping = parse_nodes(nodes)
    end

    def walk
      current_node = node_mapping[START_ADDRESS]
      sendable_instructions.cycle.each_with_index do |direction, index|
        current_node = node_mapping[current_node.send(direction)]
        if current_node.address == END_ADDRESS
          return index + 1
        end
      end
    end

    private

    def sendable_instructions
      instructions.chars.map { |direction| get_method_from_direction(direction) }
    end

    def parse_nodes(nodes)
      nodes.each_with_object({}) do |node, mapping|
        mapping[node.address] = node
      end
    end

    def get_method_from_direction(direction)
      if direction == "R"
        :right
      else
        :left
      end
    end
  end

  class << self
    def part_one(input)
      Day08::Map.from_array(input).walk
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
