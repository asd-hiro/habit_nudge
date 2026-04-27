class RenameStatusToConditionInCharacters < ActiveRecord::Migration[7.1]
  def change
    # rename_column :テーブル名, :元のカラム名, :新しいカラム名
    rename_column :characters, :status, :condition
  end
end
