def dist(a,b)
    return (a[0]-b[0]).abs + (a[1]-b[1]).abs
end


input = File.readlines('input.txt')

data = {}
input.each do |line|
    line = line.split(" ")
    s_x = line[2]
    s_y = line[3]
    b_x = line[8]
    b_y = line[9]
    s_x = s_x[2..-1].to_i
    s_y = s_y[2..-1].to_i
    b_x = b_x[2..-1].to_i
    b_y = b_y[2..-1].to_i
    data[[s_x,s_y]] = [b_x,b_y]

end

target_y = 2000000
not_here = []

data.each do |sensor, beacon|
    dist = dist(sensor,beacon)
    diff = (target_y - sensor[1]).abs
    max_horizontal_diff = dist-diff
    #Test if y of interest is even coverd by sensor
    if(!(max_horizontal_diff < 0))
        #it is, so find out how far horizontal the range goes
        horizontal_diff = max_horizontal_diff
        while(horizontal_diff >= 0)
            not_here.append(sensor[0]-horizontal_diff)
            not_here.append(sensor[0]+horizontal_diff) 
            horizontal_diff = horizontal_diff - 1
        end
    end
end
not_here = not_here.uniq
#Remove all Beacons since they are not not-beacos
data.each do |sensor, beacon|
    if(beacon[1] == target_y)
        not_here.delete(beacon[0])
    end
end
puts not_here.length
