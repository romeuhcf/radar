class CreateChatRooms < ActiveRecord::Migration
  def change
    create_table :chat_rooms do |t|
      t.references :owner, polymorphic: true, index: true, null: false
      t.belongs_to :destination, index: true, foreign_key: true

      t.integer :archived_by_id, index: true, null: true, default: nil
      t.integer :last_contacted_by_id, index: true, null: true, default: nil

      t.boolean :answered, default: false
      t.boolean :archived, default: false

      t.timestamps null: false
    end
    add_index :chat_rooms, [:owner_id, :owner_type, :answered, :archived, :last_contacted_by_id], name: 'idx_chat_rooms_active'
    add_foreign_key :chat_rooms, :users, column: :last_contacted_by_id
  end
end
