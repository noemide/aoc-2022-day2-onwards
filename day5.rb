def build_crate_stacks(crate_lines)
    crate_stack_labels = crate_lines[crate_lines.length-1].split(" ")
    expected_stacks = crate_stack_labels.length
    crate_lines.pop
    crate_stacks = Hash.new { |h, k| h[k] = [] }

    crate_lines.each do |crate_line|
        counter = 0
        crate_line = crate_line.chars
        while counter < crate_stack_labels.length
            if crate_line[0] == "["
                crate_stacks[crate_stack_labels[counter]].prepend(crate_line[1])
            end
            crate_line = crate_line[4..-1]
            counter = counter+1
        end
    end
    return crate_stacks,crate_stack_labels
end

def execute_instruction_line_cm9000(crate_stacks,line)
    line = line.split(" ")
    crate_num = line[1].to_i
    from_stack = line[3]
    to_stack = line[5]
    counter = 0
    while counter < crate_num
        crate = crate_stacks[from_stack].pop
        crate_stacks[to_stack].push(crate)
        counter = counter + 1
    end
    return crate_stacks
end

def execute_instruction_line_cm9001(crate_stacks,line)
    line = line.split(" ")
    crate_num = line[1].to_i
    from_stack = line[3]
    to_stack = line[5]
    
    counter = 0
    crates = []
    while counter < crate_num
        crates.push(crate_stacks[from_stack].pop)
        counter = counter + 1
    end
    while !crates.empty?
        crate_stacks[to_stack].push(crates.pop)
    end
    return crate_stacks
end

lines = File.readlines('input.txt')
crate_lines = []
counter = 0
curr_line = lines[counter]
while !curr_line.strip.empty?
    crate_lines.push(curr_line)
    counter = counter+1
    curr_line = lines[counter]
end

instruction_lines = lines[counter+1..-1]
crate_stacks,crate_stack_labels = build_crate_stacks(crate_lines)

instruction_lines.each do |line|
    crate_stacks = execute_instruction_line_cm9001(crate_stacks,line)
end

top_crates = []

crate_stack_labels.each do |label|
    top_crate = crate_stacks[label].pop
    top_crates.push(top_crate)
end

puts top_crates