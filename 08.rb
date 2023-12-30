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
        captures = children.match(/\((?<left>[A-Z0-9]{3}), (?<right>[A-Z0-9]{3})\)/)
        [captures[:left], captures[:right]]
      end
    end

    include Comparable
    # @return [String]
    attr_reader :address
    attr_accessor :left, :right

    # @param address [String]
    def initialize(address, left = nil, right = nil)
      @address = address
      @left = left
      @right = right
    end

    def <=>(other)
      address <=> other.address
    end

    def starting_node?
      address.end_with?("A")
    end

    def ending_node?
      address.end_with?("Z")
    end

    def to_s
      address
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

    def ghost_walk
      results = []
      starting_nodes.each do |starting_node|
        results << walk_node(starting_node)
      end
      results.reduce(1, :lcm)
    end

    private

    def walk_node(node)
      sendable_instructions.cycle.each_with_index do |direction, index|
        node = node_mapping[node.send(direction)]
        if node.ending_node?
          return index + 1
        end
      end
    end

    def starting_nodes
      node_mapping.values.select(&:starting_node?)
    end

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
      map_from_input(input).walk
    end

    def part_two(input)
      map_from_input(input).ghost_walk
    end

    private

    def map_from_input(input)
      @map ||= Day08::Map.from_array(input)
    end
  end
end
