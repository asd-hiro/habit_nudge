class UsersController < ApplicationController
  # ログインしていない状態で /user にアクセスしたらログイン画面へ飛ばす
  before_action :authenticate_user!
  def show
    @user = current_user
    # マイページに表示したいデータ（例：登録しているルーティンなど）
    @routines = @user.routines
  end
end
