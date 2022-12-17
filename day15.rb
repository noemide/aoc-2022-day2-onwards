def dist(a, b)
  return (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

#Part 2
def try_merge(rangeA, rangeB)
  #puts "merging #{rangeA.inspect} and #{rangeB.inspect}"
  if (rangeA[1] < rangeB[0] || rangeB[1] < rangeA[0])
    return nil
  end
  merged_range = []
  merged_range[0] = [rangeA[0], rangeB[0]].min
  merged_range[1] = [rangeA[1], rangeB[1]].max
  return merged_range
end

#TODO broken
def merge_ranges(ranges)
  #puts ranges.inspect
  i = 0
  while (ranges.length > 2)
    #puts ranges.inspect
    curr_range = ranges[i]
    #puts curr_range.inspect
    ranges[1..-1].each do |range|
        merged = try_merge(range,curr_range)
        if(!merged.nil?)
            ranges.delete(range)
            ranges.delete(curr_range)
            ranges.prepend(merged)
            ranges = ranges.uniq
            break
        end
    end
    #No merge was possible, try with another range
    i = rand(ranges.length-1)
  end
  #Final merge attempt
  range = try_merge(ranges[0], ranges[1])
  #TODO test if whole depth is covered
  if (range.nil?)
    #puts "Unable to merge #{ranges[0].inspect} and #{ranges[1].inspect}"
    ranges.sort_by { |x| x[0] }
    return ranges[0][1] + 1
  else
    return nil
  end
end

def scan_depth(target_y, data, max)
  if target_y%100000 == 0
    puts "Scanning depth #{target_y}"
  end

  beacon_ranges = []
  data.each do |sensor, beacon|
    dist = dist(sensor, beacon)
    diff = (target_y - sensor[1]).abs
    max_horizontal_diff = dist - diff
    #Test if y of interest is even coverd by sensor
    if (!(max_horizontal_diff < 0))
      #it is, so find out how far horizontal the range goes
      horizontal_diff = max_horizontal_diff
      left = sensor[0] - horizontal_diff
      right = sensor[0] + horizontal_diff
      if (left < 0)
        left = 0
      end
      if (right > max)
        right = max
      end
      beacon_ranges.append([left, right])
    end
  end
  #Merge ranges
  #puts beacon_ranges.inspect
  x = merge_ranges(beacon_ranges)
  if x == [0,max]
    return nil
  end
  return x
end

input = File.readlines("input.txt")

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
  data[[s_x, s_y]] = [b_x, b_y]
end

=begin Part 1
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
=end

max = 4000000
b_x = -1
b_y = -1
(max + 1).times do |y_coord|
  x_coord = scan_depth(y_coord, data.dup, max)
  if (x_coord.nil?)
    next
  end
  b_x = x_coord
  b_y = y_coord
  puts "Found beacon at #{b_x},#{b_y}"
  break
end

freq = (b_x * 4000000) + b_y
puts freq
