class DropMessageCarrierInfo < ActiveRecord::Migration
  def change
    drop_table :message_carrier_infos
  end
end
