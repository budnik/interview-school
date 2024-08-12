class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.references :classroom, null: false, foreign_key: true
      t.references :teacher_subject, null: false, foreign_key: true
      t.integer :day_of_week
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
