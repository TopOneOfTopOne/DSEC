require 'yaml'

class Stock
  attr_accessor :sym , :p_cum , :cps, :amount_spent, :p_ex, :profit , :dividends , :dividends_with_franking , :amount_of_shares , :profit , :profit_with_franking , :time
  def initialize(symbol,p_cum,cps,amount_spent)
    @sym                     = symbol
    @p_cum                   = p_cum
    @cps                     = cps
    @amount_spent            = amount_spent
    @amount_of_shares        = amount_spent/p_cum
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
