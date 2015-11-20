class AddOptionsToTransmissionRequests < ActiveRecord::Migration
  def change
    add_column :transmission_requests, :options, :text
  end
end
