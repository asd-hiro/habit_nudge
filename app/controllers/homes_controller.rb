class HomesController < ApplicationController
  def index
    if user_signed_in?
      # ログインしている場合、そのユーザーのキャラクターとルーティンを取得
      @character = current_user.character
      @routines = current_user.routines.order(created_at: :desc)

      # --- 損失回避のペナルティ処理 ---
      if @character.needs_penalty?
        @character.apply_penalty!(5)
        flash.now[:alert] = '警告：24時間以上学習が行われなかったため、経験値が 5 減少しました！'
      end

      # 1. 自分の全ルーティンのIDを取得
      routine_ids = @routines.pluck(:id)

      # 2. 自分のルーティンに紐づく、かつ「今日」作成されたログを取得
      # beginning_of_day..end_of_day で「今日の0:00:00 〜 23:59:59」を指定できます
      # .where.not(ended_at: nil) を追加して、終了しているログだけを取得するようにします
      @today_logs = StudyLog.where(routine_id: routine_ids)
                            .where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)
                            .where.not(ended_at: nil) # これで「計測中」のものは除外される

      # 3. 今日の合計学習時間を集計
      @total_duration = @today_logs.sum(:duration_minutes)
    end
  end
end
