class Routine < ApplicationRecord
  belongs_to :user
  has_many :study_logs, dependent: :destroy

  # 将来、Recordモデルを作った時にこう書くことを想定した「予約席」です
  # has_many :records, dependent: :destroy

  ## ステータスの定義
  # 0: todo (未着手), 1: doing (進行中), 2: done (完了)
  enum status: { todo: 0, doing: 1, done: 2 }

  validates :content, presence: true
end
