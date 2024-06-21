class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :subject, polymorphic: true, null: false
      t.integer :action_type, null: false
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
