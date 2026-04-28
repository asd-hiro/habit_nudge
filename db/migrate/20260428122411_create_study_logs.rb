class CreateStudyLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :study_logs do |t|
      t.references :routine, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :duration_minutes
      t.integer :focus_score
      t.text :comment

      t.timestamps
    end
  end
end
