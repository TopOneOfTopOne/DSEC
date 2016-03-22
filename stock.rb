require 'yaml'

class Stock
  attr_accessor :sym , :p_cum , :cps, :amount_spent, :p_ex, :profit , :dividends , :dividends_with_franking , :amount_of_shares , :profit , :profit_with_franking , :time, :liquid, :franking, :yield, :hypo_price
  def initialize(symbol,p_cum,cps,amount_of_shares,liquid,franking)
    @sym                     = symbol
    @p_cum                   = p_cum
    @cps                     = cps
    @liquid                  = liquid
    @amount_spent            = amount_of_shares * p_cum
    @amount_of_shares        = amount_of_shares
    @franking                = franking.to_f 
    @dividends               = @amount_of_shares * (@cps/100.0)
    @franking_credits        = ((@dividends/0.7) - @dividends) * @franking
    @yield                   = (cps/p_cum)
    @hypo_price              = (pcum - (((div/100.0)/( 1 - ( (frank/100.0)*0.3 ) )) * (1-0.45))).round(4)
    @abs_path_of_file        = File.expand_path(File.dirname(__FILE__))
  end

  def save
    File.open("#{@abs_path_of_file}/data/#{@sym}.yml",'w') {|f| f.puts self.to_yaml}
  end

  def sell(p_ex)
    @time = Time.now.ctime
    @p_ex = p_ex
    @profit = -@amount_spent + (p_ex * @amount_of_shares) + @dividends
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
      Franking: #{@franking}
      Dividends: #{@dividends}
      Dividends(franked): #{@dividends_with_franking}
      Yield: #{@yield}% 
      Hypothesis price: #{@hypo_price}
      Pex: #{@p_ex}
      Profit: #{@profit}
      Profit(franked): #{@profit_with_franking}
      Liquid?: #{@liquid}
      "
    )
  end

  private

  def bl # bottom line
    bl= "<#{@time}> code: #{@sym} profit: $#{@profit} franking_credits:$#{@franking_credits} yield: #{@yield} liquidity: #{@liquid}"
    puts bl
    log(bl)
  end

  def log(data)
    File.open("#{@abs_path_of_file}/logs/#{@sym}_log.txt",'a') {|f| f.puts data}
  end

end
