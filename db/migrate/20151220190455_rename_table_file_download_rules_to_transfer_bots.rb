class RenameTableFileDownloadRulesToTransferBots < ActiveRecord::Migration
  def change
    rename_table :file_download_rules, :transfer_bots
    add_column :transfer_bots, :direction, :string, default: 'download'
  end
end
