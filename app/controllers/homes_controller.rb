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

      # --- 運命のスロット処理 ---
      # スロットが回された、かつ今日まだ回していない場合のみ実行
      if params[:spin_slot] && @character.slot_available?
        # モデルで定義した spin_slot! メソッド（後述）を呼び出し
        session[:slot_result] = @character.spin_slot!
        # パラメータ(?spin_slot=true)を消すためにリダイレクト
        return redirect_to root_path, notice: "運命が決まりました！今日のミッションは「#{session[:slot_result]}」です！"
      end

      # 1日の最初のアクセス時に、既に今日スロットを回しているかチェックして表示を復元
      unless @character.slot_available?
        # セッションが空なら、最新のログなどから結果を復元するロジックも検討できますが、
        # まずはセッションに保持されているものを表示用に使用します
        @slot_result = session[:slot_result] || '今日のミッションは既に決定しています'
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
