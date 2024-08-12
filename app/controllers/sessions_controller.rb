class SessionsController < ApplicationController
  def current_user
    session[:user_id] = Student.find(params.dig(:current_user, :id)).id
    
    redirect_back(fallback_location:"/")
  end
end

