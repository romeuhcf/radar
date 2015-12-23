class CreateNamedTimeSpans < ActiveRecord::Migration
  def change
    create_table :named_time_spans do |t|
      t.integer :span
      t.string :name

      t.timestamps null: false
    end
    begin
      NamedTimeSpan.reset_column_information
      NamedTimeSpan.create(name: "asap", span:  10.seconds)
      NamedTimeSpan.create(name: "1.minute", span:  1.minute)
      NamedTimeSpan.create(name: "5.minutes", span:  5.minutes)
      NamedTimeSpan.create(name: "30.minutes", span:  30.minutes)
      NamedTimeSpan.create(name: "1.hour", span:  1.hours)
      NamedTimeSpan.create(name: "2.hours", span:  2.hours)
      NamedTimeSpan.create(name: "3.hours", span:  3.hours)
      NamedTimeSpan.create(name: "4.hours", span:  4.hours)
      NamedTimeSpan.create(name: "5.hours", span:  5.hours)
      NamedTimeSpan.create(name: "6.hours", span:  6.hours)
      NamedTimeSpan.create(name: "7.hours", span:  7.hours)
      NamedTimeSpan.create(name: "8.hours", span:  8.hours)
      NamedTimeSpan.create(name: "9.hours", span:  9.hours)
      NamedTimeSpan.create(name: "10.hours", span:  10.hours)
      NamedTimeSpan.create(name: "24.hours", span:  24.hours)
      NamedTimeSpan.create(name: "36.hours", span:  36.hours)
      NamedTimeSpan.create(name: "48.hours", span:  48.hours)
      NamedTimeSpan.create(name: "1.week", span:  1.week)
      NamedTimeSpan.create(name: "2.weeks", span:  2.weeks)
    rescue
      p $!.class
      p $!.message
    end
  end
end
