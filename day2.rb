

def elf_rps_char_to_num (rps_char)
    case rps_char
    when 'A'
        return 1
    when 'B'
        return 2
    when 'C'
        return 3
    end
end

def my_rps_char_to_num (rps_char)
    case rps_char
    when 'X'
        return 1
    when 'Y'
        return 2
    when 'Z'
        return 3
    end
end

def get_rps_score (line)
    elf_rps = line[0]
    my_rps =  line[2]
    elf_rps = elf_rps_char_to_num(elf_rps)
    my_rps = my_rps_char_to_num(my_rps)

    return get_rps_score_num(elf_rps,my_rps)
end

def get_rps_score_num (elf_rps, my_rps)
    match_result = my_rps-elf_rps

    case match_result
    when 1
        score = 6 + my_rps
    when 0
        score = 3 + my_rps
    when -2
        score = 6 + my_rps
    else
        score = my_rps
    end

    return score
end

def calculate_rps_response(line)
    elf_rps = line[0]
    elf_rps = elf_rps_char_to_num(elf_rps)
    goal = line[2]
    my_rps = -1
    case goal
    when 'X'
        my_rps = elf_rps-1
    when 'Y'
        my_rps = elf_rps
    when 'Z'
        my_rps = elf_rps+1
    end

    if(my_rps == 0)
        my_rps = 3
    end
    if(my_rps == 4)
        my_rps = 1
    end
    return my_rps
end

=begin Teil 1
total_score = 0
File.readlines('input.txt').each do |line|
    total_score += get_rps_score(line)
end
puts total_score 
=end

total_score = 0
File.readlines('input.txt').each do |line|
    my_rps = calculate_rps_response(line)
    elf_rps = elf_rps_char_to_num(line[0])
    total_score += get_rps_score_num(elf_rps,my_rps)
end
puts total_score 