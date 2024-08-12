class Student < ApplicationRecord
  has_and_belongs_to_many :sections
  has_many :teacher_subjects, through: :sections
  has_many :subjects, through: :teacher_subjects

  validates :first_name, :last_name, presence: true

  def first_and_last_name
    "#{first_name} #{last_name}"
  end
end
