class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.integer :plan_id, null: false
      t.integer :user_id, null: false, unique: true
      t.timestamps
    end
  end
end
