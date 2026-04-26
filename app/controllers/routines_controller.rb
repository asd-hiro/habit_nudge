class RoutinesController < ApplicationController
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

  private

  def routine_params
    params.require(:routine).permit(:content)
  end
end
