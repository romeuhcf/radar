class CreateFtpConfigurations < ActiveRecord::Migration
  def change
    create_table :ftp_configs do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :host
      t.integer :port
      t.string :user
      t.string :secret
      t.boolean :passive
      t.string :kind

      t.timestamps null: false
    end
    add_reference :transfer_bots, :ftp_config, index: true, foreign_key: true
  end
end
