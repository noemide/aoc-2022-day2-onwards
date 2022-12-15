def draw_line(dim, coord, target)
    rock = []
    if(target[dim]<coord[dim])
        # "we go down or left"
        curr = coord
        while(curr[dim]>=target[dim])
            rock.append(curr.to_s)
            curr[dim] = curr[dim]-1
        end
    elsif(target[dim]>coord[dim])
        #puts "we go up or right"
        curr = coord
        while(curr[dim]<=target[dim])
            rock.append(curr.to_s)
            curr[dim] = curr[dim]+1
        end
    end
    return rock
end


input = File.readlines('input.txt')

sand_source = [500,0]
max_x = 500
min_x = 500
max_y = 0
min_y = 0

structures = []
input.each do |line|
    line = line.split(" -> ")
    structure = []
    line.each do |coord_string|
        coord_string=coord_string.split(",")
        x = coord_string[0].to_i
        y = coord_string[1].to_i
        structure.append([x,y])
        if(x < min_x)
            min_x = x
        elsif(x > max_x)
            max_x = x
        end
        if(y < min_y)
            min_y = y
        elsif(y > max_y)
            max_y = y
        end
    end
    structures.append(structure)
end

rock  = []
#"Draw" strcutures
structures.each do |structure|
    corners = structure.length
    rock_structure = []
    structure.each_with_index do |coord, index|
        #puts "#{coord} to #{structure[index+1]}"
        if(index == (corners - 1))
            #No need to draw another line from last coordinates
            break
        end
        target = structure[index+1]
        #Figure out wheather this line is horizontal or vertical
        if(target[0]==coord[0])
            #puts "call on y"
            rock_structure.concat(draw_line(1,coord,target))
        elsif(target[1]==coord[1])
            #puts "call on x"
            rock_structure.concat(draw_line(0,coord,target))
        end
    end
    rock_structure = rock_structure.uniq
    rock.concat(rock_structure)
end

not_air = rock.dup

into_the_abyss = false
sand_counter = 0
curr = [-1,-1]
while(into_the_abyss == false)
    #Simulate one piece of sand
    #Because 0,0 is in the upper left corner, sand falls "up"
    curr[0] = sand_source[0]
    curr[1] = sand_source[1]-1
    next_step = sand_source.dup
    while(!next_step.nil?)
        #test for limit
        if(next_step[1]> max_y)
            into_the_abyss = true
            break
        end
        curr = next_step.dup
        next_step = nil
        cand = [-1,-1]
        #Try to fall straight down
        cand[0] = curr[0]
        cand[1] = curr[1]+1
        if(!not_air.include?(cand.to_s))
            next_step = cand
        else
            #Try to fall down and left
            cand[0] = curr[0]-1
            cand[1] = curr[1]+1
            if(!not_air.include?(cand.to_s))
                next_step = cand
            else
                #Try to fall down and right
                cand[0] = curr[0]+1
                cand[1] = curr[1]+1
                if(!not_air.include?(cand.to_s))
                    next_step = cand
                end
            end
        end
    end
    if(!into_the_abyss)
        not_air.append(curr.to_s)
        sand_counter += 1
        if sand_counter%100 == 0
            puts sand_counter
        end
    end
end
puts sand_counter