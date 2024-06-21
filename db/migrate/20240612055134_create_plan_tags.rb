class CreatePlanTags < ActiveRecord::Migration[6.1]
  def change
    create_table :plan_tags do |t|
      t.references :plan, foreign_key: true, null: false
      t.references :tag, foreign_key: true, null: false
      t.timestamps
    end

    add_index :plan_tags, [:plan_id,:tag_id], unique: true
  end
end