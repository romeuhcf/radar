class AddParseConfigToTransmissionRequests < ActiveRecord::Migration
  def change
    add_reference :transmission_requests, :parse_config, index: true, foreign_key: true
    remove_column :transmission_requests, :options
  end
end
