class AddDestinationToMessage < ActiveRecord::Migration
  def change
    add_reference :messages, :destination, index: true, foreign_key: true
  end
end
