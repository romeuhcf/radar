class AddDirectionToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :outgoing, :boolean, default: true
  end
end
