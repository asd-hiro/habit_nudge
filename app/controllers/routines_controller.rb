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
    # トランザクションを使って、ルーティンの更新とキャラの成長を同時に行う
    Routine.transaction do
      @routine.done!

      # ログインユーザーのキャラクターを取得して経験値を加算
      character = current_user.character
      character.exp += 10 # 経験値の獲得量はここを調整する
      character.save!
    end

    redirect_to root_path, notice: 'ルーティン達成！経験値を10獲得しました！'
  rescue ActiveRecord::RecordInvalid
    redirect_to root_path, alert: 'エラーが発生しました。'
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
