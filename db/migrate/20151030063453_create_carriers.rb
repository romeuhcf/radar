class CreateCarriers < ActiveRecord::Migration
  def change
    create_table :carriers do |t|
      t.string :media
      t.string :name
      t.boolean :active, default: false
      t.string :implementation_class
      t.text :configuration
      t.timestamps null: false
    end

    add_index :carriers, [:active, :media]
  end
end
