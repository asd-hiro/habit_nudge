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
    # ステータスを 'done' に更新
    if @routine.done!
      redirect_to root_path, notice: 'ルーティンを達成しました！お疲れ様です！'
    else
      redirect_to root_path, alert: 'ステータスの更新に失敗しました。'
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
