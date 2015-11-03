class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :transmission_request

      t.string :media
      t.string :transmission_state
      t.date :reference_date

      t.integer :weight, default: 1
      t.boolean :paid, default: false

      t.datetime :scheduled_to
      t.datetime :sent_at

      t.boolean :billable
      t.belongs_to :bill

      t.timestamps null: false
    end
    add_index :messages, [:media, :paid, :transmission_state, :reference_date], name: 'idx_mesages_report'
    add_index :messages, [:bill_id]
    add_index :messages, [:transmission_request_id]
  end
end
