require 'yaml'


def compare_ints(left,right)
    if right < left
        return false
    elsif right > left
        return true
    else
        return nil
    end
end

def compare_lists(left,right)
    correct = nil
    index = 0
    while(correct.nil?)
        if(left[index].nil?)
            if(right[index].nil?)
                return nil
            else
                return true
            end
        elsif(right[index].nil?)
            return false
        end
        if(left[index].is_a? Integer)

           if(right[index].is_a? Integer)

                correct = compare_ints(left[index],right[index])

            elsif right[index].is_a? Array

                left = [left[index]]
                right = right[index]
                correct = compare_lists(left,right)

            end

        elsif left[index].is_a? Array

            if(right[index].is_a? Integer)

                left = left[index]
                right = [right[index]]
                correct = compare_lists(left,right)

            elsif right[index].is_a? Array
                correct = compare_lists(left[index],right[index])
            end
        end
        index += 1
    end
    return correct
end

input = File.readlines('input.txt')

counter = 0
correct_indices =[]
while(input.length > counter)
    lineA = input[counter]
    lineB = input[counter+1]
    left = YAML.load(lineA)
    right = YAML.load(lineB)
    correct_order = compare_lists(left,right)
    if(correct_order)
        correct_indices.append((counter/3)+1)
    end
    counter = counter + 3
end

puts correct_indices.sum