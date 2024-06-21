class CreateViewCounts < ActiveRecord::Migration[6.1]
  def change
    create_table :view_counts do |t|
      t.references :user, null: true, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.string :user_or_ip, null: false

      t.timestamps
    end
    add_index :view_counts, [:user_or_ip, :plan_id], unique: true
  end
end
