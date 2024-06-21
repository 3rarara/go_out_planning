class AddIndexesToPlansAndPlanDetails < ActiveRecord::Migration[6.1]
  def change
    add_index :plans, :title
    add_index :plans, :body, length: 255
    add_index :plan_details, :title
    add_index :plan_details, :body, length: 255
  end
end
