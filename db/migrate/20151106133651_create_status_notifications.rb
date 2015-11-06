class CreateStatusNotifications < ActiveRecord::Migration
  def change
    create_table :status_notifications do |t|
      t.belongs_to :route_provider, index: true, foreign_key: true
      t.belongs_to :message, index: true, foreign_key: true
      t.string :provider_status

      t.timestamps null: false
    end
  end
end
