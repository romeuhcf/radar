class AddRemotePathToFileDownloadRule < ActiveRecord::Migration
  def change
    add_column :file_download_rules, :remote_path, :string
    add_column :file_download_rules, :patterns, :string
    add_column :file_download_rules, :source_delete_after, :boolean
  end
end
