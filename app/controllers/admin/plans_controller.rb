class Admin::PlansController < ApplicationController
  before_action :authenticate_admin!

  def index
    @plans = Plan.includes(:user).where(users: { is_active: true })
  end

  def show
    @plan = Plan.find(params[:id])
    @plan_details = @plan.plan_details
  end

  def edit
  end

  def update
  end

  def destroy
    @plan = Plan.find(params[:id])
    if @plan.destroy
      flash[:notice] = "プランを削除しました"
      redirect_to admin_root_path
    else
      @plan = Plan.find(params[:id])
      @plan_details = @plan.plan_details
      flash.now[:alert] = "プランを削除できませんでした"
      render 'show'
    end
  end

end
