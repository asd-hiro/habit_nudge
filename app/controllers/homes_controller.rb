class HomesController < ApplicationController
  def index
    if user_signed_in?
      @routines = current_user.routines.order(created_at: :desc)
    end
  end
end
