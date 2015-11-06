class DropTableCarriers < ActiveRecord::Migration
  def change
    drop_table :carriers
  end
end
