class CreateTransmissionRequests < ActiveRecord::Migration
  def change
    create_table :transmission_requests do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :requested_via
      t.string :status
      t.date :reference_date
      t.integer :messages_count
      t.integer :estimated_request_bytes_total
      t.integer :estimated_request_bytes_progress
      t.integer :transmissions_done
      t.float :success_rate

      t.timestamps null: false
    end
    add_index :transmission_requests, [:user_id, :requested_via, :status, :reference_date], name: 'idx_requests_for_user_report'
    add_index :transmission_requests, [:requested_via, :status, :reference_date], name: 'idx_requests_for_admin_report'
  end
end
