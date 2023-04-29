require 'rails_helper'

RSpec.describe IexClientService, type: :service do
  let(:iex_client_service) { IexClientService.new }
  let(:iex_api_wrapper) { instance_double('IexApiWrapper') }

  before { allow(IexApiWrapper).to receive(:new).and_return(iex_api_wrapper) }

  describe '#quote' do
    let(:quote) { double('quote') }

    before do
      allow(iex_api_wrapper).to receive(:quote).with('AAPL').and_return(quote)
    end

    it 'returns the quote for a given symbol' do
      result = iex_client_service.quote('AAPL')
      expect(result).to eq(quote)
    end
  end

  describe '#stock_market_list' do
    let(:market_type) { 'gainers' }
    let(:market_list) { double('market_list') }

    before do
      allow(iex_api_wrapper).to receive(:stock_market_list)
        .with(market_type)
        .and_return(market_list)
    end

    it 'returns the stock market list for a given market type' do
      result = iex_client_service.stock_market_list(market_type)
      expect(result).to eq(market_list)
    end
  end

  describe '#chart' do
    let(:chart) { double('chart') }

    before do
      allow(iex_api_wrapper).to receive(:chart).with('AAPL').and_return(chart)
    end

    it 'returns the chart for a given symbol' do
      result = iex_client_service.chart('AAPL')
      expect(result).to eq(chart)
    end
  end

  describe '#ref_data_symbols' do
    let(:ref_data_symbols) { double('ref_data_symbols') }

    before do
      allow(iex_api_wrapper).to receive(:ref_data_symbols).and_return(
        ref_data_symbols,
      )
    end

    it 'returns the reference data symbols' do
      result = iex_client_service.ref_data_symbols
      expect(result).to eq(ref_data_symbols)
    end
  end
end
