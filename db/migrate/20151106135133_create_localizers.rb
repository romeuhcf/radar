class CreateLocalizers < ActiveRecord::Migration
  def change
    create_table :localizers do |t|
      t.references :item, polymorphic: true, index: true
      t.string :uid

      t.timestamps null: false
    end

    add_index :localizers, [:item_type, :uid]
  end
end
