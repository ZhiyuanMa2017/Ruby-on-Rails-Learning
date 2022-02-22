class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments do |t|
      t.belongs_to :user, index: true, dependent: :destroy
      t.belongs_to :course, index: true, dependent: :destroy
      t.timestamps
    end
  end
end
