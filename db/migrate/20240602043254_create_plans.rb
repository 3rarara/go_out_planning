class CreatePlans < ActiveRecord::Migration[6.1]
  def change
    create_table :plans do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :body
      t.boolean :is_draft, null: false, default: false
      t.string :plan_search
      t.timestamps
    end
  end
end
