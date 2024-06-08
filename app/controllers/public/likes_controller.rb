class Public::LikesController < ApplicationController
  before_action :set_plan

  def create
    like = current_user.likes.new(plan_id: @plan.id)
    like.save
    redirect_to request.referer
  end

  def destroy
    like = current_user.likes.find_by(plan_id: @plan.id)
    like.destroy
    redirect_to request.referer
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

end
