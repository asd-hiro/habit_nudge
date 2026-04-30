class AddLastPenaltyAtToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :last_penalty_at, :datetime
  end
end
