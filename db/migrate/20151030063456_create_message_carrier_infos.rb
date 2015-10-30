class CreateMessageCarrierInfos < ActiveRecord::Migration
  def change
    create_table :message_carrier_infos do |t|
      t.belongs_to :carrier, index: true, foreign_key: true
      t.string :carrier_hash, index: true
      t.string :carrier_status
      t.belongs_to :message, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
