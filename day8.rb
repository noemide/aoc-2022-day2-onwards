# x = north-south, y= east-west

def can_be_seen_from_north?(x,y,forest)
    #first tree to check is one step to the north
    index = x+1
    while index < forest.length
        if forest[x][y] <= forest[index][y]
            #we found a larger tree to this one cannot be seen
            #puts "for ["+x.to_s+","+y.to_s+"] ("+forest[x][y].to_s+") found ["+x.to_s+","+index.to_s+"]("+forest[x][y].to_s+")"
            return false
        end
        index +=1
    end
    #we tried all trees to the north and only found smaller ones, so this one is visible
    return true
end

def can_be_seen_from_south?(x,y,forest)
    #first tree to check is one step to the south
    index = x-1
    while index >= 0
        if forest[x][y] <= forest[index][y]
            #we found a larger tree so this one cannot be seen
            return false
        end
        index = index-1
    end
    #we tried all trees to the south and only found smaller ones, so this one is visible
    return true
end

def can_be_seen_from_east?(x,y,forest)
    #first tree to check is one step to the east
    index = y+1
    while index < forest[x].length
        if forest[x][y] <= forest[x][index]
            #we found a larger tree so this one cannot be seen
            return false
        end
        index +=1
    end
    #we tried all trees to the east and only found smaller ones, so this one is visible
    return true
end

def can_be_seen_from_west?(x,y,forest)
    #first tree to check is one step to the west
    index = y-1
    while index >= 0
        if forest[x][y] <= forest[x][index]
            #we found a larger tree so this one cannot be seen
            return false
        end
        index = index-1
    end
    #we tried all trees to the west and only found smaller ones, so this one is visible
    return true
end


def viewing_distance_to_north(x,y,forest)
    #first tree to check is one step to the north
    index = x+1
    while index < forest.length
        if forest[x][y] <= forest[index][y]
            #we found a larger tree
            return index-x
        end
        index +=1
    end
    #we tried all trees to the north and only found smaller ones, so max viewing distance
    return forest.length-(x+1)
end

def viewing_distance_to_south(x,y,forest)
    #first tree to check is one step to the south
    index = x-1
    while index >= 0
        if forest[x][y] <= forest[index][y]
            #we found a larger tree
            return x-index
        end
        index = index-1
    end
    #we tried all trees to the south and only found smaller ones
    return x
end

def viewing_distance_to_east(x,y,forest)
    #first tree to check is one step to the east
    index = y+1
    while index < forest[x].length
        if forest[x][y] <= forest[x][index]
            #we found a larger tree
            return index-y
        end
        index +=1
    end
    #we tried all trees to the east and only found smaller ones
    return forest[x].length-(y+1)
end

def viewing_distance_to_west(x,y,forest)
    #first tree to check is one step to the west
    index = y-1
    while index >= 0
        if forest[x][y] <= forest[x][index]
            #we found a larger tree
            return y-index
        end
        index = index-1
    end
    #we tried all trees to the west and only found smaller ones
    return y
end

input = lines = File.readlines('input.txt')
#change order so we can parse the list in order while still having the south west corder at 0,0
input = input.reverse
forest = []
visiblity = []
row_counter = 0
input.each_with_index do |line, index|
    forest[index] = []
    visiblity[index] = []
    line.chars.each_with_index do |char, index_colum|
        if char != "\n"
            forest[index][index_colum] = char.to_i
        end
    end
end

max_scenic_score = 0
forest.each_with_index do |row,index_x|
    row.each_with_index do |pos, index_y|
         scenic_score = viewing_distance_to_north(index_x,index_y,forest) * viewing_distance_to_south(index_x,index_y,forest) * viewing_distance_to_east(index_x,index_y,forest) * viewing_distance_to_west(index_x,index_y,forest)
        if scenic_score > max_scenic_score
           max_scenic_score = scenic_score
        end
        #puts "for ["+index_x.to_s+" , "+index_y.to_s+" ] : " + viewing_distance_to_south(index_x,index_y,forest).to_s
    end
end
puts max_scenic_score
=begin part 1
counter = 0
forest.each_with_index do |row,index_x|
    row.each_with_index do |pos, index_y|
        visiblity[index_x][index_y] = can_be_seen_from_north?(index_x,index_y,forest) || can_be_seen_from_south?(index_x,index_y,forest) || can_be_seen_from_east?(index_x,index_y,forest) || can_be_seen_from_west?(index_x,index_y,forest)
        if visiblity[index_x][index_y]
           counter += 1
        end
    end
end
puts counter  
=end


