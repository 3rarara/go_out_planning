class Public::CommentsController < ApplicationController

  def create
    plan = Plan.find(params[:plan_id])
    comment = current_user.comments.new(comment_params)
    comment.plan_id = plan.id
    comment.save
    redirect_to request.referer
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to request.referer
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
