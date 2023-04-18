class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper

  before_action :require_login
  helper_method :current_user, :logged_in?, :custom_formatter, :find_user_info

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

  def custom_formatter(
    number,
    precision = 2,
    type = 'currency',
    unit = '',
    custom_format = '%u %n'
  )
    if type == 'stock'
      number_to_currency(
        number,
        precision: precision,
        separator: '.',
        delimiter: ',',
        unit: unit,
        format: custom_format,
      )
      #
    elsif type == 'custom'
      number_to_currency(
        number,
        precision: precision,
        separator: '.',
        delimiter: ',',
        unit: unit,
        format: custom_format,
      )
    else
      if number >= 1_000_000_000
        # If the number is greater than or equal to 1 million, format it as $1M
        number_to_currency(
          number / 1_000_000_000,
          precision: precision,
          format: '$%nB',
        )
      elsif number >= 1_000_000 && number < 1_000_000_000
        # If the number is greater than or equal to 1 million, format it as $1M
        number_to_currency(
          number / 1_000_000,
          precision: precision,
          format: '$%nM',
        )
      elsif number >= 1_000 && number < 1_000_000
        # If the number is greater than or equal to 1 thousand, format it as $234K
        number_to_currency(number / 1_000, precision: precision, format: '$%nK')
      else
        # Otherwise, format it as a regular currency with 2 decimal places
        number_to_currency(
          number,
          precision: precision,
          separator: '.',
          delimiter: ',',
        )
      end
    end
  end

  def find_user_info(user_id)
    User.find_by(id: user_id)
  end

  def initialize_iex_client
    @iex_client ||= IexClientService.new
  end
end
