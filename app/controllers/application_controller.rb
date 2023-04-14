class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper

  before_action :require_login
  helper_method :current_user, :logged_in?, :convert_currency

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless current_user || allowed_pages.include?(request.path)
      redirect_to sign_in_path
    end
  end

  def allowed_pages
    [root_path, signup_path, sign_in_path]
  end

  def convert_currency(number)
    if number >= 1_000_000_000
      # If the number is greater than or equal to 1 million, format it as $1M
      number_to_currency(number / 1_000_000_000, precision: 1, format: '$%nB')
    elsif number >= 1_000_000 && number < 1_000_000_000
      # If the number is greater than or equal to 1 million, format it as $1M
      number_to_currency(number / 1_000_000, precision: 1, format: '$%nM')
    elsif number >= 1_000 && number < 1_000_000
      # If the number is greater than or equal to 1 thousand, format it as $234K
      number_to_currency(number / 1_000, precision: 1, format: '$%nK')
    else
      # Otherwise, format it as a regular currency with 2 decimal places
      number_to_currency(number, precision: 2, separator: '.', delimiter: ',')
    end
  end

  def initialize_iex_client
    @iex_client = IexClientService.new(Rails.application.secrets.iex_api_key)
  end
end
