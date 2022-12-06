input = lines = File.readlines('input.txt')[0].chars

char_buffer = []
counter = 0
while counter < input.length
    if counter < 14
        char_buffer.push(input[counter])
    else 
        char_buffer.push(input[counter])
        char_buffer.shift
        if char_buffer.uniq == char_buffer
            puts counter+1
            break
        end
    end
    counter = counter + 1
end
