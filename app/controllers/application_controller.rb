class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  
    def logged_in?
      current_user.present?
    end

    def initialize_iex_client
      @client = IEX::Api::Client.new(
        publishable_token: 'pk_787827c9cdee408796d3f12c21a8eebb',
        secret_token: 'sk_4fdc4b7b76d0465e8649b5367aa63018',
        endpoint: 'https://cloud.iexapis.com/v1', # use 'https://sandbox.iexapis.com/v1' for Sandbox
      )
    end
  end
  