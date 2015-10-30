class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :key
      t.string :description
      t.string :default
      t.string :value

      t.timestamps null: false
    end
    add_index :configurations, :key
  end
end
