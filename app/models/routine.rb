class Routine < ApplicationRecord
  belongs_to :user

  # 将来、Recordモデルを作った時にこう書くことを想定した「予約席」です
  # has_many :records, dependent: :destroy

  validates :content, presence: true
end
