def move_knot (h_pos,t_pos)

    dist_x = h_pos[0]-t_pos[0]
    dist_y = h_pos[1]-t_pos[1]
    if(dist_x.abs <= 1 && dist_y.abs <= 1)
        #h & t are touching
        return t_pos
    end
    
    if (dist_y > 0)
        t_pos[1] += 1
    elsif (dist_y < 0)
        t_pos[1] -= 1
    end

    if (dist_x > 0)
        t_pos[0] += 1
    elsif (dist_x < 0)
        t_pos[0] -= 1
    end

    return t_pos
end

def pos_to_string(pos)
    return "["+pos[0].to_s+","+pos[1].to_s+"]"
end


input = File.readlines('input.txt')

pos_covered = []
rope = []

i = 0
while i < 10
    rope[i] = [0,0]
    i += 1
end

pos_covered.append(pos_to_string(rope[9]))

input.each do |line|

    parts = line.split(" ")
    direction = parts[0]
    steps = parts[1].to_i
    counter = 0
    case direction
    when "R"
        while counter < steps
            #move head
            rope[0][0] = rope[0][0]+1
            i = 1
            while i < 10
                rope[i] = move_knot(rope[i-1],rope[i])
                i+=1
            end
            pos_covered.append(pos_to_string(rope[9]))
            counter += 1
        end
    when "L"
        while counter < steps
            #move head
            rope[0][0] = rope[0][0]-1
            i = 1
            while i < 10
                rope[i] = move_knot(rope[i-1],rope[i])
                i+=1
            end
            pos_covered.append(pos_to_string(rope[9]))
            counter += 1
        end
    when "U"
        while counter < steps
            #move head
            rope[0][1] = rope[0][1]+1
            i = 1
            while i < 10
                rope[i] = move_knot(rope[i-1],rope[i])
                i+=1
            end
            pos_covered.append(pos_to_string(rope[9]))
            counter += 1
        end
    when "D"
        while counter < steps
           #move head
           rope[0][1] = rope[0][1]-1
           i = 1
           while i < 10
               rope[i] = move_knot(rope[i-1],rope[i])
               i+=1
           end
           pos_covered.append(pos_to_string(rope[9]))
           counter += 1
        end
    else
        puts "Error: Invalid direction "+direction
    end

end
pos_covered = pos_covered.uniq
puts pos_covered.length