class AddGeocodingColumnToPostImage < ActiveRecord::Migration[6.1]
  def change
    add_column :plan_details, :address, :string, null: false, default: ""
    add_column :plan_details, :latitude, :float, null: false, default: 0
    add_column :plan_details, :longitude, :float, null: false, default: 0
  end
end
