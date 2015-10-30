class CreateMessageContents < ActiveRecord::Migration
  def change
    create_table :message_contents do |t|
      t.string :kind
      t.references :message, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
