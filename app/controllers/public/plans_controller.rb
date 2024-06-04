class Public::PlansController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  before_action :user_is_active, only: [:show]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def new
    @plan = Plan.new
    # PlanDetailsモデルのインスタンス作成
    @plan_detail = @plan.plan_details.build
  end

  def index
    @plans = Plan.includes(:user).where(users: { is_active: true })
  end

  def show
    @plan_details = @plan.plan_details
  end

  def create
    @plan = current_user.plans.new(plan_params)
    if @plan.save
      flash[:notice] = "プランを投稿しました"
      redirect_to plan_path(@plan)
    else
      flash.now[:alert] = "プランを投稿できませんでした"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      flash[:notice] = "プランを編集しました"
      redirect_to plan_path(@plan)
    else
      flash.now[:alert] = "プランを編集できませんでした"
      render 'edit'
    end
  end

  def destroy
    if @plan.destroy
      flash[:notice] = "プランを削除しました"
      redirect_to mypage_path
    else
      flash.now[:alert] = "プランを削除できませんでした"
      render 'show'
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :body, :description, plan_details_attributes: [:id, :title, :body])
  end

  def ensure_current_user
    plan = Plan.find(params[:id])
    unless plan.user == current_user
      redirect_to plans_path
    end
  end

  def user_is_active
    user = @plan.user
    if user.is_active?
    else
      flash[:alert] = "指定のユーザーは退会済みです"
      redirect_to mypage_path
    end
  end

end
