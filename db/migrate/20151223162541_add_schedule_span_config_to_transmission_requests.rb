class AddScheduleSpanConfigToTransmissionRequests < ActiveRecord::Migration
  def change
    add_reference :transmission_requests, :schedule_span_config, index: true, foreign_key: true
  end
end
