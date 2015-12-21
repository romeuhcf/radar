class CreateParseConfigs < ActiveRecord::Migration
  def change
    create_table :parse_configs do |t|
      t.string :kind
      t.references :owner, polymorphic: true, index: true
      t.string :name
      t.boolean :message_defined_at_column
      t.string :column_of_message
      t.string :column_of_number
      t.string :column_of_destination_reference
      t.string :schedule_start_time
      t.string :schedule_finish_time
      t.string :timing_table
      t.string :field_separator
      t.boolean :headers_at_first_line
      t.text :custom_message
      t.integer :skip_records, default: 0

      t.timestamps null: false
    end
  end
end
