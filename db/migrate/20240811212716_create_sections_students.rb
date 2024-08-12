class CreateSectionsStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :sections_students do |t|
      t.references :section, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
    end
  end
end
