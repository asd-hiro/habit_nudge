class RenameNicknameToCharacterNameInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :nickname, :character_name
  end
end
