require_relative 'stock.rb'

class Terminal
  attr_accessor :stock
  def initialize
    print_intro
    @abs_path = File.expand_path(File.dirname(__FILE__))
  end

  def print_intro
    puts "===========Dividend Stripping earnings calculator (DSER) by Noobling============"
    puts(
    "Format for new stock:
      [symbol] [buy share price] [cps] [number of shares] [liquid?] [franked?]")
    puts "Type 'h' for help"
  end

  def get_query
    print "Enter command: "
    query = gets.chomp.split
    command = query[0]
    payload = query[1..-1]
    [command,payload]
  end

  def load_stock(payload)
      puts "  Attempting to load #{payload[0]}..."
      Stock.load("#{@abs_path}/data/#{payload[0]}.yml")
  end

  def new_stock(payload)
    puts "  Attempting to create #{payload[0]}..."
    raise ArgumentError if payload.length != 6 
    stock = Stock.new(payload[0],payload[1].to_f,payload[2].to_f,payload[3].to_i,payload[4],payload[5])
    stock.save
    stock
  end

  def print_help
    puts "
          (l)oad   <code>
          (sell)   <price>
          (stock)  <[symbol] [buy share price] [cps] [number of shares] [liquid?] [franked?]>
          (q)uit
          (d)etails
          (h)elp
         "
  end

  def sell_stock(price)
    @stock.sell(price[0].to_f)
    puts "  writing to #{@abs_path}/#{@stock.sym}_log.txt..."
    @stock.save 
  end

  def run
    loop do
      begin 
        execute(get_query)
      rescue NoMethodError 
        puts "  You need to (l)oad or make a new (stock) to issue this command"
        retry 
      rescue Errno::ENOENT 
        puts "  No such file try again."
        retry
      rescue ArgumentError
        puts "  Entered too many or too few arguments, try again." 
        retry
      end
    end
    puts "Terminal session ended"
  end

  def execute(query)
    command,payload = query
    case command
      when 'l'
        @stock = load_stock(payload)
        @stock.details
      when 'stock'
        @stock = new_stock(payload)
        @stock.details
      when 'sell'
        sell_stock(payload)
      when 'q'
        raise "  Interrupted by user"
      when 'h'
        print_help
      when 'd'
        @stock.details
      else puts "  No such command"
    end
  end
end

Terminal.new.run

