class AddParseConfigToTransferBots < ActiveRecord::Migration
  def change
    add_reference :transfer_bots, :parse_config, index: true, foreign_key: true
  end
end
