class Public::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def create
    unless current_user.is_active?
      reset_session
      return redirect_to new_user_registration_path, alert: "退会したユーザーはいいねできません"
    end

    @like = current_user.likes.new(plan_id: @plan.id)
    @like.save
  end

  def destroy
    @like = current_user.likes.find_by(plan_id: @plan.id)
    @like.destroy
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

end
