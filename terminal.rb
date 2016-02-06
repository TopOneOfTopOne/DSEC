require_relative 'stocks.rb'

class Terminal
  attr_accessor :stock
  def initialize
    print_intro
    @stock = execute_intro(get_query)
  end

  def print_intro
    puts "===========Dividend Stripping earnings calculator (DSER) by Noobling============"
    puts "Format for new stock: [symbol] [buy share price] [cps] [money spent]"
    puts "Load or create a new stock, type 'help' for help"
  end

  def get_query
    print "Dank it: "
    query = gets.chomp.split
    command = query[0]
    payload = query[1..-1]
    [command,payload]
  end

  def execute_intro(query)
    command,payload = query
    case command
      when 'help' then print_intro_help
      when 'load'
        puts "  Loading #{payload[0]}..."
        load_stock(payload)
      when 'stock'
        puts " Creating new stock #{payload[0]}"
        new_stock(payload)
      else
        raise "unknow command, exiting because error handling is too dank for me"
    end
  end

  def print_intro_help
    puts "Commands: (load) (stock) (help)"
    puts "(load) filename.yml"
    puts "(stock) [symbol] [buy share price] [cps] [money spent]"
  end

  def load_stock(payload)
    Stock.load(payload[0])
  end

  def new_stock(payload)
    Stock.new(payload[0],payload[1].to_f,payload[2].to_i,payload[3].to_i)
  end

  def print_greeting
    puts "Type 'help' for available commands"
  end

  def print_help
    puts "Commands: (sell) (save) (quit)"
    puts "(sell) [price ex-dividend]"
  end

  def run
    print_greeting
    loop do
      execute(get_query)
    end
    puts "Terminal session ended"
  end

  def execute(query)
    command,payload = query
    case command
      when 'sell'
        @stock.sell(payload[0].to_f)
        puts "  writing to #{@stock.sym}_log.txt..."
      when 'save' then @stock.save
      puts "Saving to #{@stock.sym}.yml"
      when 'quit'
        raise "Interrupted by user"
      when 'help'
        print_help
      else puts "No such command"
    end
  end
end

Terminal.new.run
