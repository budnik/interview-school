class SectionsController < ApplicationController
  def create
    Section.find(params[:id]).students << current_user

    redirect_to schedule_path
  end
end
