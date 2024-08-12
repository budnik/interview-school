class ApplicationController < ActionController::Base
  before_action :current_user

  def current_user
    @current_user ||= Student.find_by(id: session[:user_id])
  end
end
