class AddNotNullToPlanSearchInPlans < ActiveRecord::Migration[6.1]
  def change
    change_column :plans, :plan_search, :string, null: false, default: ''
  end
end
