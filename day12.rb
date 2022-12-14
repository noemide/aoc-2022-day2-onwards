require 'rgl/path'
require 'rgl/adjacency'
require 'rgl/dijkstra'

$graph = RGL::DirectedAdjacencyGraph.new
$map = []

def chart_north(x,y)
    if $map[x][y+1].ord-$map[x][y].ord <= 1
        $graph.add_edge([x,y],[x,y+1])
    end
end

def chart_south(x,y)
    if $map[x][y-1].ord-$map[x][y].ord <= 1
        $graph.add_edge([x,y],[x,y-1])
    end
end

def chart_east(x,y)
    if $map[x+1][y].ord-$map[x][y].ord <= 1
        $graph.add_edge([x,y],[x+1,y])
    end
end

def chart_west(x,y)
    if $map[x-1][y].ord-$map[x][y].ord <= 1
        $graph.add_edge([x,y],[x-1,y])
    end
end


input = File.readlines('input.txt')
s = []
e = []
cand_vertices=[]

input.each_with_index do |line, line_index|
    line = line.strip
    line = line.chars
    line.each_with_index do |char, char_index|
        if $map[char_index].nil?
            $map[char_index] = []
        end
        $map[char_index][line_index] = char
        $graph.add_vertex([char_index,line_index])
        if char == "a"
            cand_vertices.append([char_index,line_index])
        end
        if(char == "S")
            s = [char_index, line_index]
            $map[char_index][line_index] = "a"
            cand_vertices.append([char_index,line_index])
        end
        if(char == "E")
            e = [char_index, line_index]
            $map[char_index][line_index] = "z"
        end
    end
end

#Add vertices
x_counter = 0
while x_counter < $map.length
    y_counter = 0
    while y_counter < $map[0].length
        if x_counter > 0
            chart_west(x_counter,y_counter)
        end
        if x_counter < ($map.length-1)
           chart_east(x_counter,y_counter)     
        end
        if y_counter > 0
            chart_south(x_counter,y_counter)
        end
        if y_counter < ($map[0].length-1)
            chart_north(x_counter,y_counter)
        end
        y_counter += 1
    end
    x_counter +=1
end
edge_weights_map = Hash.new(1)


=begin Part 1
shortest_path = $graph.dijkstra_shortest_path(edge_weights_map,s,e)
puts shortest_path.length-1 
=end

shortest_dist = 10000000

cand_vertices.each do |vertex|
    if $graph.path?(vertex,e)
        shortest_path = $graph.dijkstra_shortest_path(edge_weights_map,vertex,e)
        if shortest_path.length-1 < shortest_dist
            shortest_dist = shortest_path.length-1
        end
    end   
end

puts shortest_dist
