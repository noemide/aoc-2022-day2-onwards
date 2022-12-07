require 'tree'


def create_all_children(lines, node)
    line = lines[0]
    counter = 0
    while lines.length > counter && !line.start_with?("$")
        parts = line.split(" ");
        if parts[0] == "dir"
            node << Tree::TreeNode.new(parts[1])
        else
            node << Tree::TreeNode.new(parts[1], parts[0].to_i)
        end
    counter += 1
    line = lines[counter]
    end
    return lines[counter..-1],node
end
    

def navigate_tree(lines,node)
    line = lines[0]
    counter = 0
    while lines.length > counter && line.start_with?("$")
        parts = line.split(" ");
        if parts[1] == "ls"
            break
        elsif parts[1] == "cd"
            if parts[2] == ".."
                node = node.parent
            else
                node = node[parts[2]]
                if node.nil?
                    puts "Error: node "+ parts[2]+ " not found"
                    return nil
                end
            end
        else
            puts "Error: Invalid instruction sequence"
            return nil
        end
    counter += 1
    line = lines[counter]
    end
return lines[counter..-1], node
end

def build_tree(lines, root_node)
# first line is expected to be an "$ ls"
    if !lines[0].include?"$ ls"
        puts "Error: Expecting first line of tree building instructions to be \"$ ls\", was "+lines[0]
        return nil
    end
    curr_node = root_node
    while lines.length > 1
        lines, curr_node = create_all_children(lines[1..-1], curr_node)
        lines, curr_node = navigate_tree(lines, curr_node)
    end
    return root_node
end

def get_and_write_node_value(node)
    if node.content?
        return node.content
    end
    value = 0
    node.children.each do |child|
        value += get_and_write_node_value(child)
    end
    node.content = value
    return value
end

input = lines = File.readlines('input.txt')
root_node = Tree::TreeNode.new("/")
root_node = build_tree(input[1..-1],root_node)
get_and_write_node_value(root_node)

=begin Part 1
small_dirs = 0
root_node.each do |node|
    if !node.leaf? && node.content <= 100000
        small_dirs += node.content
    end
end 
puts small_dirs
=end

total_disc_size = 70000000
required_disc_space = 30000000
curr_free_space = total_disc_size - root_node.content
missing_space = required_disc_space-curr_free_space
cand_dirs = []
root_node.each do |node|
    if !node.leaf? && node.content >= missing_space
        cand_dirs.push node.content
    end
end 
dir_size = cand_dirs.sort[0]
puts dir_size