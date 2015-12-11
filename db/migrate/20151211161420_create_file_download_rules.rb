class CreateFileDownloadRules < ActiveRecord::Migration
  def change
    create_table :file_download_rules do |t|
      t.string :worker_class, index:true
      t.references :owner, polymorphic: true, index: true
      t.boolean :enabled, index:true
      t.string :description
      t.text :transfer_options
      t.text :process_options
      t.string :schedule
      t.string :status
      t.datetime :last_success_at
      t.datetime :last_failed_at
      t.text :last_log

      t.timestamps null: false
    end
  end
end
