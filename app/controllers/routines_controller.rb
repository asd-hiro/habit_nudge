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

  private

  def set_routine
    # ログインユーザーが所有するルーティンのみを対象にするのがポイント！
    @routine = current_user.routines.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:content)
  end
end
