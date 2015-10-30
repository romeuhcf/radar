class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :kind
      t.string :address
      t.integer :contacted_times
      t.date :last_used_at

      t.timestamps null: false
    end
    add_index :destinations, [:kind, :last_used_at, :contacted_times]
  end
end
