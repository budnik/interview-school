class Classroom < ApplicationRecord
  has_many :sections
  has_many :students, through: :sections
  has_many :teacher_subjects, through: :sections
  has_many :teachers, through: :teacher_subjects
  has_many :subjects, through: :teacher_subjects
end
