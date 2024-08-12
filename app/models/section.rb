class Section < ApplicationRecord
  belongs_to :classroom
  belongs_to :teacher_subject
  has_one :teacher, through: :teacher_subject
  has_and_belongs_to_many :students

  enum day_of_week: [ :everyday, :mwf, :tt ]

  delegate :name, to: :classroom, prefix: true

  scope :running_at, ->(dt) { where('tsrange(starts_at::timestamp,ends_at::timestamp)@>any(array[?]::timestamp[])', dt) }

  def subject
    teacher_subject.subject.name
  end

  def teacher_name
    teacher_subject.teacher.first_and_last_name
  end
end
