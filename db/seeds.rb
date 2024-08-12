Rails.logger = Logger.new(STDOUT)
Rake::Task['db:fixtures:load'].invoke

## Generate teachers schedules
#
# Would create section for each teacher subject, makes sure teacher have no overlapping sections.
# Classrooms magicaly generated for each section.
classroom_id = 1
TeacherSubject.all.each do |teacher_subject|
  duration = [50, 80].sample # Pick random duration
  slots = (7..20).flat_map do |h|
    [
      Time.new(1970, 1, 1, h, 0),
      Time.new(1970, 1, 1, h, 30)
    ]
  end

  slots << Time.new(1970, 1, 1, 7, 30)
  slots << Time.new(1970, 1, 1, 21, 0) if duration == 50

  day_of_week = Section.day_of_weeks.keys.sample
  
  # Pick random time
  slots.shuffle.take_while do |starts_at|
    ends_at = starts_at + duration.minutes

    # Find conflicts
    relation = Section.where(teacher_subject: teacher_subject.teacher.teacher_subjects, 
                             day_of_week: [day_of_week, 'everyday'].uniq)
    relation.where(starts_at: starts_at..ends_at)
      .or(relation.where(ends_at: starts_at..ends_at))
      .present? or break Section.create!(day_of_week:,
                                         starts_at:,
                                         ends_at:,
                                         teacher_subject:,
                                         classroom: Classroom.create(name: "Classroom ##{classroom_id+=1}"))
  end
end

