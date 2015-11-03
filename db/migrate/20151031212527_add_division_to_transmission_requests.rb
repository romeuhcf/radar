class AddDivisionToTransmissionRequests < ActiveRecord::Migration
  def change
    add_reference :transmission_requests, :division, index: true, foreign_key: true
  end
end
