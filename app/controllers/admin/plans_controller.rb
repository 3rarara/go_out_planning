class Admin::PlansController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_plan, only: [:edit, :update, :destroy]

  def index
    @plans = Plan.active_users.published.order(created_at: :desc)
    @drafts = Plan.active_users.draft.order(created_at: :desc)
  end

  def edit
    @plan_details = @plan.plan_details
    @plan_tags = @plan.tags
  end

  def update
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
    if @plan.destroy
      redirect_to admin_root_path, notice: "プランを削除しました"
    else
      @plan_details = @plan.plan_details
      @plan_tags = @plan.tags
      flash.now[:alert] = "プランを削除できませんでした"
      render 'edit'
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def create_notifications
    Notification.create(subject: @plan, user: @plan.user, action_type: :hidden_plan)
  end

  def plan_params
   params.require(:plan).permit(:is_draft)
  end

end