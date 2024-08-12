class SectionsController < ApplicationController
  def create
    section_students << current_user
    redirect_to schedule_path
  end

  def destroy
    section_students.destroy(current_user)
    redirect_to schedule_path
  end

  private

  def section_students
    @section_students ||= Section.find(params[:id]).students
  end
end
