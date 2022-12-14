require 'yaml'

class Package
    attr_accessor :content
    def initialize(content)
        @content = content
    end

    def to_s
        return content.inspect
    end
end

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

                correct = compare_lists([left[index]],right[index])

            end

        elsif left[index].is_a? Array

            if(right[index].is_a? Integer)

                correct = compare_lists(left[index],[right[index]])

            elsif right[index].is_a? Array
                correct = compare_lists(left[index],right[index])
            end
        end
        index += 1
    end
    return correct
end

input = File.readlines('input.txt')

=begin part 1
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
=end

def quicksort(input_list)
    if(input_list.length == 1 || input_list.length == 0)
        return input_list
    end
    pivot = rand(0..(input_list.length-1))
    p_item = input_list[pivot]
    input_list.delete(p_item)
    small_list = []
    large_list = []
    input_list.each do |element|
        if compare_lists(p_item.content,element.content)
            large_list.append(element)
        else
            small_list.append(element)
        end
    end
    small_list = quicksort(small_list)
    large_list = quicksort(large_list)
    return small_list.append(p_item).concat(large_list)
end

div1 = Package.new([[2]])
div2 = Package.new([[6]])
all_pkgs = []
all_pkgs.append(div1)
all_pkgs.append(div2)
input.each do |line|
    if !line.strip.empty?
        all_pkgs.append(Package.new(YAML.load(line)))
    end
end
all_pkgs = quicksort(all_pkgs)
puts (all_pkgs.find_index(div1)+1)*(all_pkgs.find_index(div2)+1)

