class Public::PlansController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_plan, only: [:show, :edit, :update, :destroy, :liked_users]
  before_action :user_is_active, only: [:show]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def new
    @plan = Plan.new
    # PlanDetailsモデルのインスタンス作成
    @plan_detail = @plan.plan_details.build
    @drafts = current_user.plans.where(is_draft: true).order(created_at: :desc)
  end

  def index
    @plans = Plan.includes(:user).where(users: { is_active: true }, is_draft: false).order(created_at: :desc)
    @plan_details = @plans.flat_map(&:plan_details)

    # ユーザーがサインインしている場合、フォロー中のユーザーのPlanに絞り込む
    @followed_plans = if user_signed_in?
                        followed_users = current_user.followings
                        @plans.where(user: followed_users)
                      else
                        []
                      end

    @tags = Tag.all
  end

  def show
    if @plan.is_draft
      if @plan.user != current_user
        # 他のユーザーの下書き投稿へのアクセスを防ぐ
        redirect_to root_path, alert: 'このプランは現在閲覧できません。'
        return
      end
    end

    @plan_details = @plan.plan_details
    @comment = Comment.new
    @tag_list = @plan.tags.pluck(:name).join(',')
    @plan_tags = @plan.tags

    # 閲覧数カウント
    user_or_ip = current_user ? current_user.id.to_s : request.remote_ip
    unless ViewCount.find_by(user_or_ip: user_or_ip, plan: @plan)
      ViewCount.create(user_or_ip: user_or_ip, plan: @plan, user: current_user)
    end
  end

  def create
    @plan = current_user.plans.new(plan_params)
    @plan.is_draft = params[:commit] == "下書き保存"
    tag_list = params[:plan][:tags].split(',') if params[:plan][:tags]

    # 不適切なコンテンツのチェック
    if plan_params[:plan_image].present?
      result = Vision.image_analysis(plan_params[:plan_image])
      unless result
        flash.now[:alert] = "アップロードされた画像に不適切なコンテンツが含まれています"
        render 'new'
      end
    end

    if @plan.save
      @plan.save_plan_tags(tag_list) if tag_list
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
    @tag_list = @plan.tags.pluck(:name).join(',')
  end

  def update
    @plan.is_draft = params[:commit] == "下書き保存"
    tag_list = params[:plan][:tags].split(',') if params[:plan][:tags]

    # 不適切なコンテンツのチェック
    if plan_params[:plan_image].present?
      result = Vision.image_analysis(plan_params[:plan_image])
      unless result
        flash.now[:alert] = "アップロードされた画像に不適切なコンテンツが含まれています"
        render 'edit' and return
      end
    end

    if @plan.update(plan_params)
      @plan.tags.destroy_all if tag_list
      @plan.save_plan_tags(tag_list) if tag_list

      if @plan.is_draft
        redirect_to new_plan_path, notice: "下書きが保存されました"
      else
        redirect_to plan_path(@plan), notice: "プランを編集しました"
      end
    else
      flash.now[:alert] = "プランを編集できませんでした"
      render 'edit'
    end
  end

  def destroy
    if @plan.destroy
      redirect_to mypage_path, notice: "プランを削除しました"
    else
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

  def tags_list
    tags = Tag.where('name LIKE ?', "%#{params[:q]}%").map { |tag| { id: tag.id, text: tag.name } }
    render json: tags
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

  def user_is_active
    user = @plan.user
    if user.is_active?
    else
      redirect_to mypage_path, alert: "指定のユーザーは退会済みです"
    end
  end

  def plan_params
    params.require(:plan).permit(:title, :body, :is_draft, :plan_image, :description, plan_details_attributes: [:id, :title, :body, :_destroy, :address, :latitude, :longitude])
  end

end
