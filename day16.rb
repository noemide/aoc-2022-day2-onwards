require 'rgl/path'
require 'rgl/adjacency'
require 'rgl/dot'
require 'rgl/dijkstra'

#Define my own Class since rgls class does not work for this use case
class EdgeWeightsMap

    attr_reader :map

    def initialize()
      @map = Hash.new
    end

    def get_weight(u, v)
        property = @map[[u, v]]
    end

    def set_weight(u,v,weight)
        @map[[u,v]] = weight
        @map[[v,u]] = weight
    end

    def remove(u,v)
        @map.delete([u,v])
        @map.delete([v,u])
    end

    def to_s
        entries = []
        @map.each do |edge, weight|
            edge_s = "#{edge[0].to_s}->#{edge[1].to_s}"
            weight_s = "[#{weight}]"
            entries.append(edge_s+":"+weight_s)
        end
        return entries.inspect
    end

  end



class Valve
    attr_reader :label, :flow_rate
    def initialize(label, flow_rate)
        @label = label
        @flow_rate = flow_rate
    end

    def to_s
        return "#{label}(#{flow_rate})"
    end

end


def plot_path(path,lengths)
    rep = []
    pos = 1
    rep.append("#{path[0]}@#{node_values[path[0]]}")
    while pos < path.length-1
        v = path[pos]
        u = path[pos+1]
        length = lengths.get_weight(v,u)
        rep.append("--#{length}->#{u}@#{node_values[u]}")
        pos += 1
    end
    return rep.join

end

def get_path_length(path, edge_length)
    length = 0
    pos = 0
    while pos < path.length-1
        length += edge_length.get_weight(path[pos],path[pos+1])+1
        pos += 1
    end
end

def find_best_path(graph,lengths,time_left,path_so_far,pressure_released_so_far)
    curr_node = path_so_far[-1]
    neighbors = graph.adjacent_vertices(curr_node)
    #puts "neighbors for #{curr_node} are #{neighbors.inspect}"
    best_path = path_so_far
    best_pressure = pressure_released_so_far
    neighbors.each do |n|
        #puts "Trying to move from #{curr_node} to #{n}"
        time_left_at_neighbor = ((time_left-lengths.get_weight(curr_node,n))-1)
        unless time_left_at_neighbor <= 0 || path_so_far.include?(n)
            #Try moving to neighbor
            pressure_released_at_n = pressure_released_so_far + (n.flow_rate*time_left_at_neighbor)
            path_with_n = path_so_far.dup.append(n)
            n_path,n_value = find_best_path(graph,lengths,time_left_at_neighbor,path_with_n,pressure_released_at_n)
            if n_value > best_pressure
                #puts "so far best choice after #{curr_node} is #{n} with #{n_value}"
                best_path = n_path
                best_pressure = n_value
            end
        end
    end
    return best_path,best_pressure
end


input = File.readlines('input.txt')
graph = RGL::AdjacencyGraph.new
vertices = {}

#Fist add nodes
start = nil
input.each do |line|
    label = line.split(" ")[1]
    flow_rate = line.split(" ")[4]
    flow_rate = flow_rate.split("=")[1]
    flow_rate = flow_rate.chars
    flow_rate.pop
    flow_rate = flow_rate.join.to_i
    vertex = Valve.new(label, flow_rate)
    if (label == "AA")
        start = vertex
    end
    graph.add_vertex(vertex)
    vertices[label] = vertex
end

#Then add edges
lengths = EdgeWeightsMap.new
input.each do |line|
    edges_to = line.split(" ")[9..-1]
    source = vertices[line.split(" ")[1]]
    edges_to.each do |target|
        target = vertices[target.chars[0..1].join]
        graph.add_edge(source,target)
        lengths.set_weight(source,target,1)
    end
end

#Expand graph: Since valves do not need to be opened, add direct edges if there is a path between nodes
to_be_added = []
graph.each_vertex do |v|
    paths = []
    graph.each_vertex do |u|
        unless v == u 
            path = graph.dijkstra_shortest_path(lengths.map,v,u)
            paths.append(path)
            length = path.length-1
            to_be_added.append([path[0],path[-1],length])
        end
    end
end
to_be_added.each do |edge|
    graph.add_edge(edge[0],edge[1])
    #Now this edge has a weight differnt from one so store that
    lengths.set_weight(edge[0],edge[1],edge[2])
end

#Simplify graph: remove all vertices with non-valves ("flow = 0") exept AA
#No need to replace lost edges since we already expanded all path in previous step
graph.each_vertex do |v|
    if v.flow_rate == 0 && v != start
        graph.remove_vertex(v)
        graph.each_vertex do |u|
            lengths.remove(v,u)
        end

    end
  end

#puts lengths

graph.write_to_graphic_file
# Set the step limit
#Part 1
step_limit = 30
#Part 2
#step_limit = 26

# Find the maximum value path starting from node "AA"
#(graph,lengths,time_left,path_so_far,pressure_released_so_far
path, max = find_best_path(graph, lengths, step_limit, [start],0)
#puts plot_path(path,lengths)
puts path.join
puts max 

