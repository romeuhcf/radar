class RemoveSchedulingFromParseConfig < ActiveRecord::Migration
  def change
    remove_column :parse_configs, :timing_table
    remove_column :parse_configs, :schedule_start_time
    remove_column :parse_configs, :schedule_finish_time
  end
end
