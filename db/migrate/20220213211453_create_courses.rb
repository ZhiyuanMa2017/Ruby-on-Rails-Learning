class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :weekday_one
      t.string :weekday_two
      t.string :start_time
      t.string :end_time
      t.string :course_code
      t.integer :capacity
      t.integer :student_num, default: 0
      t.string :status, default: "OPEN"
      t.string :class_room, null: false

      t.belongs_to :teacher

      t.timestamps
    end
  end
end
