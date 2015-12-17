class CreateApiClients < ActiveRecord::Migration
  def change
    create_table :api_clients do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :secret_key
      t.datetime :last_used_at
      t.boolean :enabled
      t.string :description

      t.timestamps null: false
    end

    add_index :api_clients, [:secret_key, :enabled]
  end
end
