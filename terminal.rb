require_relative 'stock.rb'

class Terminal
  attr_accessor :stock
  def initialize
    print_intro
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
    puts "  Loading #{payload[0]}..."
    Stock.load("data/#{payload[0]}.yml")
  end

  def new_stock(payload)
    puts "  Creating new stock #{payload[0]}..."
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
    puts "  writing to #{@stock.sym}_log.txt..."
    @stock.save 
  end

  def run
    loop do
      execute(get_query)
    end
    puts "Terminal session ended"
  end

  def execute(query)
    command,payload = query
    case command
      when 'l'
        @stock = load_stock(payload)
      when 'stock'
        @stock = new_stock(payload)
      when 'sell'
        sell_stock(payload)
      when 'q'
        raise "Interrupted by user"
      when 'h'
        print_help
      when 'd'
        @stock.details
      else puts "No such command"
    end
  end
end

Terminal.new.run

