input = File.readlines('input.txt')

record = {}
clock = 1
curr_val = 1
record[clock] = curr_val
input.each do |line|
    if line.include?("noop")
        clock += 1
        record[clock] = curr_val
    else
        line = line.split(" ")
        offset= line[1].to_i
        clock += 1
        record[clock] = curr_val
        clock += 1
        curr_val = curr_val+offset
        record[clock] = curr_val
    end
end

=begin part 1
sum = record[20]*20 + record[60]*60 + record[100]*100 + record[140]*140 + record[180]*180 + record[220]*220
puts sum 
=end
pixels = []
record.each_pair do |key, value|
    cycle = key
    sprite_pos = value
    curr_drawn = cycle%40
    pixel = ""
    if curr_drawn == 0
        curr_drawn = 40
    end
    #Coordinates start from zero but cycles from one
    curr_drawn = curr_drawn-1
    if (curr_drawn-sprite_pos).abs < 2
        pixel = "#"
    else
        pixel = "."
    end
    pixels[cycle] = pixel
end
puts record[10].to_s
puts pixels[1..40].join('')
puts pixels[41..80].join('')
puts pixels[81..120].join('')
puts pixels[121..160].join('')
puts pixels[161..200].join('')
puts pixels[201..240].join('')