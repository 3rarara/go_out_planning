class Public::PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  def new
    @plan = Plan.new
    # PlanDetailsモデルのインスタンス作成
    @plan.plan_details.build
  end

  def show
    @plan_details = @plan.plan_details
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
    params.require(:plan).permit(:title, :body, :description, plan_details_attributes: [:title, :body])
  end

end
