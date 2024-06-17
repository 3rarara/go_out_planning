class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @plan = Plan.find(params[:plan_id])
    @comment = current_user.comments.new(comment_params)
    @comment.plan_id = @plan.id
    if @comment.save
      flash.now[:notice] = "コメントを投稿しました"
      # redirect_to request.referer
    else
      flash.now[:alert] = "コメントを投稿できませんでした"
      # @plan = Plan.find(params[:plan_id])
      # @plan_details = @plan.plan_details
      # @comment = Comment.new
      # render 'public/plans/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @plan = @comment.plan
    if @comment.destroy
      flash.now[:notice] = "コメントを削除しました"
      # redirect_to request.referer
    else
      # @plan = Plan.find(params[:plan_id])
      # @plan_details = @plan.plan_details
      # @comment = Comment.new
      flash.now[:alert] = "コメントを削除できませんでした"
      # render 'public/plans/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
