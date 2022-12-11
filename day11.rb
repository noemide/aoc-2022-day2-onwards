$multiple = 1
class Monkey

    @@monkey_list = []

    def self.monkey_list
        return @@monkey_list
    end

    attr_accessor :items, :operation, :divisor, :true_monkey_no, :false_monkey_no
    attr_reader :inspection_count

    def initialize
        @items = []
        @operation = []
        @inspection_count = 0
    end

    def do_turn
        while !@items.empty?
            @items[0] = self.inspect(@items[0])
            self.throw_item
        end
    end

    def inspect(item)
        @inspection_count += 1
        operator = @operation[1]
        left = self.replace_param(@operation[0],item)
        right = self.replace_param(@operation[2],item)
        if operator == "+"
            item = left + right
        elsif operator == "*"
            item = left * right
        else
            puts "Error: Unknown operator "+operator
            return nil
        end
        # part 1 
        #Ruby integer division already rounds down
        #return item / 3
        if (item%$multiple == 0)
            return $multiple
        else
            return item%$multiple
        end
        
    end

    def throw_item
        item = @items[0]
        divisor = @divisor
         if item%divisor == 0
            Monkey.monkey_list[true_monkey_no].catch_item(item)
         else
            Monkey.monkey_list[false_monkey_no].catch_item(item)
         end
         @items.shift

    end

    def replace_param(string, old_val)
        if(string == "old")
            return old_val
        else 
            return string.to_i
        end
    end

    def catch_item(item)
        @items.append(item)
    end

    def to_s
        return "Count: #{@inspection_count} Items: [#{@items.join(" ")}] Operation: [#{@operation.join("")}] Divisor: #{@divisor} true:#{@true_monkey_no} false:#{@false_monkey_no}"
    end

end

def parse_monkey(lines)
    #for part 2
    #Find monkey number
    monkey_no_raw = lines[0].scan(/\d+/)
    monkey_no = monkey_no_raw[0].to_i
    monkey = Monkey.new
    #Get starting items
    items_raw = lines[1].scan(/\d+/)
    items_raw.each do |item_raw|
        item = item_raw.to_i
        monkey.items.append(item)
    end
    #get operation
    operation_raw = lines[2].split(" ")
    monkey.operation = [operation_raw[3],operation_raw[4],operation_raw[5]]
    #get divisor
    monkey.divisor = lines[3].scan(/\d+/)[0].to_i
    #get true monkey
    monkey.true_monkey_no = lines[4].scan(/\d+/)[0].to_i
    #get false monkey
    monkey.false_monkey_no = lines[5].scan(/\d+/)[0].to_i
    Monkey.monkey_list[monkey_no] = monkey
    return monkey.divisor
end

def do_round
    Monkey.monkey_list.each do |monkey|
        monkey.do_turn
    end
end

divisors = []
input = File.readlines('input.txt')
while !input.empty?
    divisors.append(parse_monkey(input))
    input.shift(7)
end

divisors.each do |divisor|
    $multiple = $multiple*divisor
end
puts $multiple


round_counter = 0
# part 1 
#while round_counter < 20
while round_counter < 10000
    do_round
    round_counter += 1
    if round_counter%100 == 0
        puts "Round: #{round_counter}"
    end
end


inspection_counts = []
Monkey.monkey_list.each_with_index do |monkey|
    inspection_counts.append(monkey.inspection_count)
end
inspection_counts = inspection_counts.sort.reverse

monkey_business = inspection_counts[0] * inspection_counts[1]
puts monkey_business


