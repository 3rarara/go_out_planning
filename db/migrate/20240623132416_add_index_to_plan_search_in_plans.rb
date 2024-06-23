class AddIndexToPlanSearchInPlans < ActiveRecord::Migration[6.1]
  def change
    add_index :plans, :plan_search
  end
end
