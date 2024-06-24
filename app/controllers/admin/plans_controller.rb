class Admin::PlansController < ApplicationController
  before_action :authenticate_admin!

  def index
    @plans = Plan.includes(:user).where(users: { is_active: true }, is_draft: false).order(created_at: :desc)
    @draft_plans = Plan.includes(:user).where(users: { is_active: true }, is_draft: true).order(created_at: :desc)
  end

  def edit
    @plan = Plan.find(params[:id])
    @plan_details = @plan.plan_details
    @tag_list = @plan.tags.pluck(:name).join(',')
    @plan_tags = @plan.tags
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.is_draft = params[:commit] == "非表示"
    if @plan.update(plan_params)
      @plan.is_draft
      create_notifications
      redirect_to edit_admin_plan_path(@plan), notice: "投稿を非表示にしました"
    else
      flash.now[:alert] = "プランを編集できませんでした"
      render 'edit'
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    if @plan.destroy
      redirect_to admin_root_path, notice: "プランを削除しました"
    else
      @plan = Plan.find(params[:id])
      @plan_details = @plan.plan_details
      flash.now[:alert] = "プランを削除できませんでした"
      render 'edit'
    end
  end

  private

  def plan_params
   params.require(:plan).permit(:is_draft)
  end

  def create_notifications
    Notification.create(subject: @plan, user: @plan.user, action_type: :hidden_plan)
  end
end