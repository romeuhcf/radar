class CreateScheduleSpanConfigs < ActiveRecord::Migration
  def change
    create_table :schedule_span_configs do |t|
      t.references :owner, polymorphic: true, index: true
      t.string :name
      t.boolean :relative
      t.datetime :start_time
      t.datetime :finish_time
      t.string :time_table
      t.boolean :reschedule_when_time_table_ends
      t.integer :start_span_id
      t.integer :finish_span_id
      t.timestamps null: false
    end

    add_foreign_key :schedule_span_configs, :named_time_spans,  column: :start_span_id
    add_foreign_key :schedule_span_configs, :named_time_spans,   column: :finish_span_id
  end
end
