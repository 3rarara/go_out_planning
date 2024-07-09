class Public::PlansController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_plan, only: [:show, :edit, :update, :destroy, :liked_users]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]
  before_action :check_user_active, only: [:show]
  before_action :check_draft_plan, only: [:show]

  def new
    @plan = Plan.new
    # PlanDetailsモデルのインスタンス作成
    @plan_detail = @plan.plan_details.build
    @drafts = current_user.plans.draft.order(created_at: :desc)
  end

  def index
    @plans = Plan.active_users.published.order(created_at: :desc)
    @plan_details = @plans.flat_map(&:plan_details)
    @tags = Tag.all

    # 未ログイン時エラー回避のため空の配列代入
    if user_signed_in?
      @followed_plans = @plans.where(user: current_user.followings)
    else
      @followed_plans = []
    end
  end

  def show
    @plan_details = @plan.plan_details
    @comment = Comment.new
    @plan_tags = @plan.tags

    # 閲覧数カウント 未ログイン時もカウント
    user_or_ip = current_user ? current_user.id.to_s : request.remote_ip
    unless ViewCount.find_by(user_or_ip: user_or_ip, plan: @plan)
      ViewCount.create(user_or_ip: user_or_ip, plan: @plan, user: current_user)
    end
  end

  def create
    @plan = current_user.plans.new(plan_params)
    @plan.is_draft = params[:commit] == "下書き保存"
    plan_tags = params[:plan][:tags].split(',') if params[:plan][:tags]

    # 不適切なコンテンツのチェック
    if plan_params[:plan_image].present?
      result = Vision.image_analysis(plan_params[:plan_image])
      unless result
        flash.now[:alert] = "アップロードされた画像に不適切なコンテンツが含まれています"
        render 'new' and return
      end
    end

    if @plan.save
      @plan.save_plan_tags(plan_tags) if plan_tags

      if @plan.is_draft
        redirect_to new_plan_path, notice: "下書きが保存されました"
      else
        redirect_to plan_path(@plan), notice: "プランを投稿しました"
      end
    else
      flash.now[:alert] = "プランを投稿できませんでした"
      render 'new'
    end
  end

  def edit
    @plan_tags = @plan.tags.pluck(:name).join(',')
  end

  def update
    @plan.is_draft = params[:commit] == "下書き保存"
    plan_tags = params[:plan][:tags].split(',') if params[:plan][:tags]

    # 不適切なコンテンツのチェック
    if plan_params[:plan_image].present?
      result = Vision.image_analysis(plan_params[:plan_image])
      unless result
        flash.now[:alert] = "アップロードされた画像に不適切なコンテンツが含まれています"
        render 'edit' and return
      end
    end

    if @plan.update(plan_params)
      @plan.tags.destroy_all if plan_tags
      @plan.save_plan_tags(plan_tags) if plan_tags

      if @plan.is_draft
        redirect_to new_plan_path, notice: "下書きが保存されました"
      else
        redirect_to plan_path(@plan), notice: "プランを編集しました"
      end
    else
      @plan_tags = @plan.tags.pluck(:name).join(',')
      flash.now[:alert] = "プランを編集できませんでした"
      render 'edit'
    end
  end

  def destroy
    if @plan.destroy
      redirect_to mypage_path, notice: "プランを削除しました"
    else
      @plan_details = @plan.plan_details
      @comment = Comment.new
      @plan_tags = @plan.tags
      flash.now[:alert] = "プランを削除できませんでした"
      render 'show'
    end
  end

  def search_tag
    @tag = Tag.find(params[:tag_id])
    @plans = @tag.plans
  end

  def liked_users
    @liked_users = @plan.liked_users
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def ensure_current_user
    plan = Plan.find(params[:id])
    unless plan.user == current_user
      redirect_to plans_path
    end
  end

  def check_user_active
    unless @plan.user.is_active?
      redirect_to mypage_path, alert: "指定のユーザーは退会済みです"
    end
  end

  def check_draft_plan
    if @plan.is_draft && @plan.user != current_user
      redirect_to plans_path, alert: 'このプランは現在閲覧できません'
    end
  end

  def plan_params
    params.require(:plan).permit(:title, :body, :is_draft, :plan_image, :description, plan_details_attributes: [:id, :title, :body, :_destroy, :address, :latitude, :longitude])
  end

end
