class CreateTransmissionRequests < ActiveRecord::Migration
  def change
    create_table :transmission_requests do |t|
      t.references :owner, polymorphic: true, index: true
      t.belongs_to :user, index: true, foreign_key: true
      t.string :identification
      t.string :requested_via
      t.string :status
      t.date :reference_date
      t.integer :messages_count
      t.timestamps null: false
    end
    add_index :transmission_requests, [:user_id, :requested_via, :status, :reference_date], name: 'idx_requests_for_user_report'
    add_index :transmission_requests, [:requested_via, :status, :reference_date], name: 'idx_requests_for_admin_report'
  end
end
