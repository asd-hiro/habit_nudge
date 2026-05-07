class RemoveNameFromCharacters < ActiveRecord::Migration[7.1]
  def change
    remove_column :characters, :name, :string
  end
end
