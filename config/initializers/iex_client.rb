IEX::Api.configure do |config|
  config.publishable_token = Rails.application.secrets.iex_api_key
  config.endpoint = 'https://cloud.iexapis.com/v1'
end
