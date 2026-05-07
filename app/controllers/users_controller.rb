class UsersController < ApplicationController
  # ログインしていない状態で /user にアクセスしたらログイン画面へ飛ばす
  before_action :authenticate_user!
  def show
    @user = current_user
    # ユーザーに紐づくキャラクターを取得
    @character = @user.character

    # 今日のルーティン一覧
    @routines = @user.routines.order(created_at: :desc)

    # 今日の学習ログを取得
    @today_logs = StudyLog.where(routine_id: @routines.pluck(:id))
                          .where(created_at: Time.zone.now.all_day)

    # duration_minutesカラムを合計（nilの場合は0にする）
    @total_duration = @today_logs.sum(:duration_minutes) || 0
  end
end
