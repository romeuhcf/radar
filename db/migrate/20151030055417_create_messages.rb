class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :customer, polymorphic: true, index: true
      t.string :media
      t.string :transmission_state
      t.date :reference_date

      t.integer :weight, default: 1
      t.boolean :billable
      t.boolean :paid, default: false

      t.datetime :scheduled_to
      t.datetime :sent_at

      t.belongs_to :bill

      t.belongs_to :transmission_request
      t.timestamps null: false
    end
    add_index :messages, [:customer_type, :customer_id, :paid, :media, :transmission_state, :reference_date], name: 'idx_messages_for_user_report'
    add_index :messages, [:media, :paid, :transmission_state, :reference_date], name: 'idx_messages_for_admin_report'
  end
end
