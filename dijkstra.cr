# an implementation of dijkstra's algorithm in Crystal

require "random"

class Coordinates
  include Comparable(Coordinates)

  getter x : Float64
  getter y : Float64

  def initialize(@x, @y)
  end

  def distance(to other : Coordinates)
    Math.sqrt((x - other.x) ** 2 + (y - other.y) ** 2)
  end

  def <=>(other : Coordinates)
    if (output = (x <=> other.x)) != 0
      return output
    end

    y <=> other.y
  end

  def_hash x, y

  def clone
    Coordinates.new x, y
  end
end

class Node
  include Comparable(Node)

  getter coords : Coordinates
  getter neighbors : Array(Node)

  def initialize(@coords, @neighbors = Array(Node).new)
  end

  def distance(to other : Node)
    coords.distance to: other.coords
  end

  def <=>(other : Node)
    coords <=> other.coords
  end

  def_hash coords

  def clone
    cloned_node = Node.new coords.clone
    cloned_node.neighbors.concat neighbors
    cloned_node
  end
end

def dijkstra_path(graph, starting_node, target_node)
  remaining_vertices = graph.clone
  distances = Hash(Node, Float64).new { Float64::INFINITY }
  previous_nodes = Hash(Node, Node).new

  distances[starting_node] = 0

  until remaining_vertices.empty?
    current = remaining_vertices.min_by { |vertex| distances[vertex] }

    remaining_vertices.delete current

    if current == target_node
      break
    end

    current.neighbors.each do |neighbor|
      alt = distances[current] + current.distance(to: neighbor)
      if alt < distances[neighbor]
        distances[neighbor] = alt
        previous_nodes[neighbor] = current
      end
    end
  end

  path = Array(Node).new
  path << target_node
  next_node = target_node
  while previous_nodes.has_key? next_node
    path.unshift previous_nodes[next_node]
    next_node = previous_nodes[next_node]
  end

  path
end

def generate_graph(num_nodes, num_neighbors, bounds : Range(Float64, Float64) = -100.0..100.0, rng = Random.new)
  nodes = Array(Node).new(initial_capacity: num_nodes)

  nodes << Node.new(Coordinates.new(rng.rand(bounds), rng.rand(bounds)))

  (num_nodes - 1).times do
    current_node = nodes.reject { |n| n.neighbors.size >= num_neighbors }.sample(rng)

    new_node = Node.new(Coordinates.new(rng.rand(bounds), rng.rand(bounds)))

    nodes << new_node
    current_node.neighbors << new_node
    new_node.neighbors << current_node
  end

  nodes.each do |node|
    other_nodes = nodes.reject node

    until node.neighbors.size >= num_neighbors
      non_neighbors = (other_nodes - node.neighbors).reject { |n| n.neighbors.size >= num_neighbors }

      if non_neighbors.empty?
        non_neighbors = other_nodes - node.neighbors
      end

      new_neighbor = non_neighbors.sample(rng)
      node.neighbors << new_neighbor
      new_neighbor.neighbors << node
    end
  end

  nodes
end

def display_graph(graph, node_ids)
  puts "|---"
  graph.each do |node|
    id = node_ids[node]
    puts "  Node #{id} (#{node.coords.x.round(2)},#{node.coords.y.round(2)}): #{node.neighbors.map { |n| node_ids[n] }.join(", ")}"
  end
  puts "|---"
end

def display_path(path, node_ids)
  s = path.map { |n| node_ids[n] }.join("->")
  puts s
end

rng = Random.new

puts "Generating graph..."
graph = generate_graph 20, 3, rng: rng

node_ids = Hash.zip graph, (0...graph.size).to_a

display_graph graph, node_ids

start_node, end_node = graph.sample(2, rng)

puts "Creating Dijkstra path from (#{node_ids[start_node]}) to (#{node_ids[end_node]})..."
path = dijkstra_path graph, start_node, end_node

display_path path, node_ids

puts "Done!"
