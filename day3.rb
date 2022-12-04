
def char_to_prio char_entry
    offset = 96
    if (char_entry.upcase == char_entry) 
        offset = 38
    end
    return char_entry.ord - offset
end

=begin part 1
sum = 0
File.readlines('input.txt').each do |line|
    first_comp,second_comp = line.partition(/.{#{line.size/2}}/)[1,2]
    first_comp = first_comp.chars
    second_comp = second_comp.chars
    intersection = first_comp & second_comp
    sum += char_to_prio(intersection[0])
end
puts sum
=end

sum = 0
lines = File.readlines('input.txt')

i = 0
while i < lines.size do
    line_a = lines[i].chars
    line_b = lines[i+1].chars
    line_c = lines[i+2].chars
    intersection = line_a & line_b & line_c
    sum += char_to_prio(intersection[0])
    i = i+3
end

puts sum