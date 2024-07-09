class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      redirect_to request.referer, notice: "コメントを削除しました"
    else
      flash.now[:alert] = "コメントを削除できませんでした"
      @plan = Plan.find(params[:plan_id])
      @plan_details = @plan.plan_details
      @plan_tags = @plan.tags
      render 'admin/plans/edit'
    end
  end

end
