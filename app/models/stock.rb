class Stock < ApplicationRecord
    has_many :transactions
    has_many :users, through: :transactions
    has_many :user_stocks, dependent: :delete_all
  
    validates :symbol, :name, presence: true
    validates :symbol, uniqueness: true
  
    def self.find_or_create_from_iex_quote(iex_client, symbol)
      quote = iex_client.quote(symbol)
      stock = find_by(symbol: quote.symbol) || create(symbol: quote.symbol, name: quote.company_name)
      [quote, stock]
    rescue IEX::Errors::SymbolNotFoundError
      raise ActiveRecord::RecordNotFound, 'Symbol not found. Please input a valid symbol.'
    end
  
    def self.filtered_symbols(iex_client, query)
      all_symbols = iex_client.ref_data_symbols
      all_symbols.select do |symbol|
        symbol.symbol.downcase.include?(query.downcase) ||
          symbol.name.downcase.include?(query.downcase)
      end
    end
  
    def self.quotes_from_filtered_symbols(iex_client, symbols)
      symbols.map { |symbol| iex_client.quote(symbol.symbol) }
    end
  
    def chart_data(iex_client)
      chart = iex_client.chart(symbol)
      chart.each_with_object({}) do |data_point, hash|
        hash[data_point['label']] = [
          data_point['open'],
          data_point['close'],
          data_point['high'],
          data_point['low'],
        ]
      end
    end
  end
  