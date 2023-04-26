class ApplicationController < ActionController::Base
  include FlashMessageHelper
  include FormatHelper

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

  def find_user_info(user_id)
    User.find_by(id: user_id)
  end

  def initialize_iex_client
    @iex_client ||= IexClientService.new
  end
end
