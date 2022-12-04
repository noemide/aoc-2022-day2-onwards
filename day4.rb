counter = 0
File.readlines('input.txt').each do |line|
    first_comp,second_comp = line.split(',')
    first_comp_lower, first_comp_upper = first_comp.split('-')
    second_comp_lower, second_comp_upper = second_comp.split('-')
    first_comp_lower = first_comp_lower.to_i
    first_comp_upper = first_comp_upper.to_i
    second_comp_lower = second_comp_lower.to_i
    second_comp_upper = second_comp_upper.to_i

=begin teil 1
    if(first_comp_lower <= second_comp_lower && first_comp_upper >= second_comp_upper)
        counter += 1
    elsif (first_comp_lower >= second_comp_lower && first_comp_upper <= second_comp_upper)
        counter += 1
    end 
=end
    if(first_comp_upper < second_comp_lower)
        counter = counter
    elsif(second_comp_upper < first_comp_lower)
        counter = counter
    else
        counter += 1
    end
end
puts counter