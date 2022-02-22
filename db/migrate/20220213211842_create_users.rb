class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.string :password_digest
      t.string :remember_digest
      t.string :major
      t.string :department
      t.string :phone_number
      t.date :birthday
      t.boolean :admin, default: false
      t.boolean :teacher, default: false
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
