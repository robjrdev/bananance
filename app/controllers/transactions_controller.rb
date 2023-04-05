class TransactionsController < ApplicationController
    before_action :initialize_iex_client

    def buy
        @transaction = Transaction.new
    end

    def sell
        @transaction = Transaction.new
    end
  end
  