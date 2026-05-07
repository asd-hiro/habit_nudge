class AddDailyMissionToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_column :characters, :daily_mission, :string
  end
end
