class HomesController < ApplicationController
  def index
    if user_signed_in?
      # ログインしている場合、そのユーザーのキャラクターとルーティンを取得
      @character = current_user.character
      @routines = current_user.routines.order(created_at: :desc)
    end
  end
end
