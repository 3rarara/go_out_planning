class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @plan = Plan.find(params[:plan_id])

    # 管理者が強制退会を実行した時に実行
    unless current_user.is_active?
      reset_session
      return redirect_to new_user_registration_path, alert: "退会したユーザーはコメントを送信できません"
    end

    @comment = current_user.comments.new(comment_params)
    @comment.plan_id = @plan.id
    if @comment.save
      flash.now[:notice] = "コメントを送信しました"
    else
      flash.now[:alert] = "コメントを送信できませんでした"
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @plan = @comment.plan
    if @comment.destroy
      flash.now[:notice] = "コメントを削除しました"
    else
      flash.now[:alert] = "コメントを削除できませんでした"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end
