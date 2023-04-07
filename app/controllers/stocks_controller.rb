class StocksController < ApplicationController
    before_action :initialize_iex_client

    def index
        @trending_stocks = @client.stock_market_list(:mostactive)
    end

    def show
    end

    def search
    end
end