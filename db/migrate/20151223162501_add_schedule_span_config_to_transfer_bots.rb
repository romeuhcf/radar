class AddScheduleSpanConfigToTransferBots < ActiveRecord::Migration
  def change
    add_reference :transfer_bots, :schedule_span_config, index: true, foreign_key: true
  end
end
