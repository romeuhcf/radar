class RemoveTransferOptionsFromFileDownloadRules < ActiveRecord::Migration
  def change
    remove_column :file_download_rules, :transfer_options
    remove_column :file_download_rules, :process_options
  end
end
