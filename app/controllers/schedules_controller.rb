class SchedulesController < ApplicationController
  before_action :fetch_available_sections, only: :show
  def show
    @student = Student.find_by(id: session[:user_id])
    redirect_to :root unless @student

    sections = current_user.sections.group_by(&:day_of_week)

    m = [sections['mwf'], sections['everyday']].flatten.compact.sort_by(&:starts_at)
    t = [sections['tt'], sections['everyday']].flatten.compact.sort_by(&:starts_at)

    @student_sections_by_day = [m,t,m,t,m]
    @available_sections = fetch_available_sections
  end

  private

  def fetch_available_sections
    busy_at = current_user
      .sections
      .pluck(:day_of_week, :starts_at, :ends_at)
      .group_by(&:shift)
      .transform_values(&:flatten)

    conflicting_sections = Section.running_at(busy_at['everyday'])
                                  .or(Section.tt.running_at(busy_at['tt']))
                                  .or(Section.mwf.running_at(busy_at['mwf']))

    Section.where.not(id: conflicting_sections)
  end
end
