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

  def starving?
    # 自分のルーティンに紐づく、終了済みの最新ログを取得
    last_log = StudyLog.where(routine_id: user.routines.pluck(:id))
                       .where.not(ended_at: nil)
                       .order(ended_at: :desc).first

    # ログが一つもない場合は、まだサボりとはみなさない（あるいは作成からの時間で判定）
    return false if last_log.nil?

    # 24時間以上経過しているか
    last_log.ended_at < 24.hours.ago
  end

  # ペナルティが必要かどうかの判定（重複防止）
  def needs_penalty?
    return false unless starving?

    # 今日すでにペナルティを受けていたら false
    # (last_penalty_at が nil、または今日より前なら true)
    last_penalty_at.nil? || last_penalty_at < Time.current.beginning_of_day
  end

  def apply_penalty!(amount)
    return unless needs_penalty?

    new_exp = [self.exp - amount, 0].max
    # 経験値を減らすと同時に、ペナルティ実行時刻を記録
    update!(exp: new_exp, last_penalty_at: Time.current)
  end

  # レベルに応じたランク名（称号）を返す
  def rank_name
    case level
    when 1..4   then 'はじまりの卵'
    when 5..9   then '見習い学習者'
    when 10..19 then '中堅エンジニア'
    else             '伝説のフルスタック'
    end
  end

  # レベルに応じた画像（または絵文字）を返す
  def image_display
    case level
    when 1..4   then '🥚' # ここを将来的に "egg.png" などのパスに変える
    when 5..9   then '🐣'
    when 10..19 then '👨‍💻'
    else             '🐉'
    end
  end
end
