class CreateRouteProviders < ActiveRecord::Migration
  def change
    create_table :route_providers do |t|
      t.string :name
      t.string :provider_klass
      t.string :options
      t.boolean :enabled
      t.boolean :priority
      t.string :service_type

      t.timestamps null: false
    end

    add_index :route_providers, [:enabled, :service_type, :name]
  end
end
