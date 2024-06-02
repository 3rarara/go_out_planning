class Public::PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def new
    @plan = Plan.new
  end

  def show
  end

  def create
    @plan = current_user.plans.new(plan_params)
    @plan.save
    # flash[:notice] = "プランを投稿しました"
    redirect_to plan_path(@plan)
  end

  def edit
  end

  def update
    @plan.update(plan_params)
    redirect_to plan_path(@plan)
  end

  def destroy
    @plan.destroy
    redirect_to mypage_path
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :body)
  end

end
