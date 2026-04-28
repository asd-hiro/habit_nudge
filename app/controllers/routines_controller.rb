class RoutinesController < ApplicationController
  before_action :set_routine, only: [:show, :edit, :update, :destroy, :update_status]
  def new
    @routine = Routine.new
  end

  def create
    @routine = current_user.routines.build(routine_params)
    if @routine.save
      redirect_to root_path, notice: '新しい学習ルーティンを登録しました！'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @routine.update(routine_params)
      redirect_to root_path, notice: 'ルーティンを更新しました！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @routine.destroy
    redirect_to root_path, notice: 'ルーティンを削除しました。'
  end

  def update_status
    # 1. 現在進行中のログを検索
    @study_log = @routine.study_logs.find_by(ended_at: nil)

    # 2. ログが存在する場合のみ、終了時刻と学習時間を計算・保存
    if @study_log
      finish_time = Time.current
      duration = ((finish_time - @study_log.started_at) / 60).to_i

      @study_log.update!(
        ended_at: finish_time,
        duration_minutes: duration
      )
    end
    # トランザクションを使って、ルーティンの更新とキャラの成長を同時に行う
    Routine.transaction do
      @routine.done!

      character = current_user.character
      before_level = character.level

      # キャラクターに経験値を与える処理をモデルに任せる
      character.add_exp(10)

      # レベルが上がっていたら通知メッセージを生成
      flash[:notice] = if character.level > before_level
                         "ルーティン達成！経験値を獲得しました！おめでとう、Lv.#{character.level}に上がりました！"
                       else
                         'ルーティン達成！経験値を獲得しました！'
                       end
    end

    redirect_to root_path
  end

  def start_study
    @routine = Routine.find(params[:id])

    # 新しくStudyLogを作成し、開始時刻を記録する
    @study_log = @routine.study_logs.create(started_at: Time.current)

    if @study_log.persisted?
      redirect_to root_path, notice: '学習を開始しました！集中しましょう。'
    else
      redirect_to root_path, alert: '学習の開始に失敗しました。'
    end
  end

  private

  def set_routine
    # ログインユーザーが所有するルーティンのみを対象にするのがポイント！
    @routine = current_user.routines.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:content)
  end
end
