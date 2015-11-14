class AddOwnerToMessages < ActiveRecord::Migration
  def change
    add_reference :messages, :owner, polymorphic: true, index: true
  end
end
