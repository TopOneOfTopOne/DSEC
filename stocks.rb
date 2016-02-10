require 'yaml'

class Stock
  attr_accessor :sym , :p_cum , :cps, :amount_spent, :p_ex, :profit , :dividends , :dividends_with_franking , :amount_of_shares , :profit , :profit_with_franking , :time, :liquid
  def initialize(symbol,p_cum,cps,amount_of_shares,liquid)
    @sym                     = symbol
    @p_cum                   = p_cum
    @cps                     = cps
    @liquid                  = liquid
    @amount_spent            = amount_of_shares * p_cum
    @amount_of_shares        = amount_of_shares
    @dividends               = @amount_of_shares * (@cps/100.0)
    @dividends_with_franking = @amount_of_shares * ((@cps/100.0)/0.7)
  end

  def save
    File.open("data/#{@sym}.yml",'w') {|f| f.puts self.to_yaml}
  end

  def sell(p_ex)
    @time = Time.now.ctime
    @p_ex = p_ex
    @profit = -@amount_spent + (p_ex * @amount_of_shares) + @dividends
    @profit_with_franking = @profit -@dividends + @dividends_with_franking
    bl
  end

  def self.load(fname)
    YAML.load(File.open(fname,'r'))
  end

  def details
    puts(
      "
      code: #{@sym}
      Pcum: #{@p_cum}
      cps: #{@cps}
      Num of shares: #{@amount_of_shares}
      Amount spent: #{@amount_spent}
      Dividends: #{@dividends}
      Dividends(franked): #{@dividends_with_franking}
      Profit: #{@profit}
      Profit(franked): #{@profit_with_franking}
      Liquid?: #{@liquid}
      "
    )
  end
  private

  def bl # bottom line
    bl= "Trading #{@sym} earned $#{@profit} or $#{@profit_with_franking} with 100% franking at #{@time}"
    puts bl
    log(bl)
  end

  def log(data)
    File.open("logs/#{@sym}_log.txt",'a') {|f| f.puts data}
  end

end

# changes (0.1)
# added liquid boolean argument
# taking stock amount instead of amount spent to give a more accurate end result
# added printing of all arguments method for easier access