class CreatePlanDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_details do |t|
      t.integer :plan_id, null: false
      t.string :title, null: false
      t.text :body
      t.timestamps
    end
  end
end
