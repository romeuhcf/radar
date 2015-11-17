class AddBatchFileToTransmissionRequests < ActiveRecord::Migration
  def change
    add_column :transmission_requests, :batch_file, :string
  end
end
