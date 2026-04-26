class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name,           null: false
      t.integer :level,         null: false, default: 1
      t.integer :exp,           null: false, default: 0
      t.integer :status,        null: false, default: 0
      t.references :user,       null: false, foreign_key: true

      t.timestamps
    end
  end
end