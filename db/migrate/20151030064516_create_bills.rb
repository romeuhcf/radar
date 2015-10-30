class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :customer, polymorphic: true, index: true
      t.date :reference_date_begin
      t.date :reference_date_end
      t.decimal :grand_total
      t.boolean :paid
      t.date :due_to

      t.timestamps null: false
    end
  end
end
