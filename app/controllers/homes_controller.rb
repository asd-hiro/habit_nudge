class HomesController < ApplicationController
  def index
    if user_signed_in?
      # ログインしている場合、そのユーザーのキャラクターとルーティンを取得
      @character = current_user.character
      @routines = current_user.routines.order(created_at: :desc)

      # --- 損失回避のペナルティ処理 ---
      if @character.needs_penalty?
        @character.apply_penalty!(5)
        flash.now[:alert] = '警告：24時間以上タスクが行われなかったため、経験値が 5 減少しました！'
      end

      # --- 運命のスロット処理 ---
      if params[:spin_slot] && @character.slot_available?
        # 1. スロットを回してDBに保存
        esult = @character.spin_slot!
        # 2. リダイレクトして結果を表示
        return redirect_to root_path, notice: "運命が決まりました！今日のミッションは「#{@slot_result}」です！"
      end

      # 既に今日回している場合
      unless @character.slot_available?
        # DBから直接結果を取り出す
        @slot_result = @character.daily_mission
      end

      # 1. 自分の全タスクのIDを取得
      routine_ids = @routines.pluck(:id)

      # 2. 自分のタスクに紐づく、かつ「今日」作成されたログを取得
      # beginning_of_day..end_of_day で「今日の0:00:00 〜 23:59:59」を指定できます
      # .where.not(ended_at: nil) を追加して、終了しているログだけを取得するようにします
      @today_logs = StudyLog.where(routine_id: routine_ids)
                            .where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)
                            .where.not(ended_at: nil) # これで「計測中」のものは除外される

      # 3. 今日の合計学習時間を集計
      @total_duration = @today_logs.sum(:duration_minutes)

      # 未完了のタスクから最新3つを取得
      @active_routines = current_user.routines.where(status: [:todo, :doing]).order(created_at: :desc)
    end
  end
end
