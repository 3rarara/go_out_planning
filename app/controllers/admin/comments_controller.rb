class Admin::CommentsController < ApplicationController

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      flash[:notice] = "コメントを削除しました"
      redirect_to request.referer
    else
      flash.now[:alert] = "コメントを削除できませんでした"
      @plan = Plan.find(params[:plan_id])
      @plan_details = @plan.plan_details
      render 'public/plans/show'
    end
  end

end