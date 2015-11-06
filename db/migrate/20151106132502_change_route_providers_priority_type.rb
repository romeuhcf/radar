class ChangeRouteProvidersPriorityType < ActiveRecord::Migration
  def change
    remove_column :route_providers, :priority
    add_column :route_providers, :priority, :integer
  end
end
