class AddLastSlotAtToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :last_slot_at, :datetime
  end
end
