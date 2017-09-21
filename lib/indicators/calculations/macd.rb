module Indicators
  #
  # Moving Average Convergence Divergence
  class Macd

    # MACD Line: (12-day EMA - 26-day EMA) 
    # Signal Line: 9-day EMA of MACD Line
    # MACD Histogram: MACD Line - Signal Line
    # Default MACD(12, 26, 9)
    def self.calculate data, parameters
      faster_periods = parameters[0]
      slower_periods = parameters[1]
      signal_periods = parameters[2]
      output = Array.new
      adj_closes = Indicators::Helper.validate_data(data, :adj_close, slower_periods+signal_periods-1)
      # puts "faster=#{faster_periods}, slower=#{slower_periods}, signal=#{signal_periods}"

      macd_line = []

      # calculate MACD line
      adj_closes.each_with_index do |adj_close, index|
        if index+1 >= slower_periods
          # Calibrate me! Not sure why it doesn't accept from or from_faster.
          faster_ema = Indicators::Ema.calculate(adj_closes[0..index], faster_periods).last
          slower_ema = Indicators::Ema.calculate(adj_closes[0..index], slower_periods).last
          macd_line[index] = faster_ema - slower_ema
          output[index] = [macd_line[index]]
  
          if index+1 >= slower_periods+signal_periods
          else 
          end

        else
          macd_line[index] = nil
          output[index] = nil
        end
      end

      # calculcate Signal line & histogram
      macd_data = Indicators::Data.new(macd_line)
      signal_line = macd_data.calc(type: :ema, params: signal_periods).output

      rev_signal_line = signal_line.reverse
      rev_output = output.reverse

      rev_signal_line.each_with_index do |sig, i|
        rev_output[i] << sig
        rev_output[i] << rev_output[i].first - sig
      end

      return rev_output.reverse

    end

  end
end