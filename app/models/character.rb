class Character < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  # レベルアップに必要な経験値（例: 100）
  LEVEL_UP_THRESHOLD = 100

  # 経験値を加算し、レベルアップを判定するメソッド
  def add_exp(amount)
    self.exp += amount

    # 経験値が閾値を超えたらレベルアップ
    while self.exp >= LEVEL_UP_THRESHOLD
      self.exp -= LEVEL_UP_THRESHOLD
      self.level += 1
    end
    save!
  end
end
