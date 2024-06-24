class Admin::TagsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tags = if params[:sort] == 'asc'
              Tag.left_joins(:plans).group(:id).order('COUNT(plans.id) ASC')
            elsif params[:sort] == 'desc'
              Tag.left_joins(:plans).group(:id).order('COUNT(plans.id) DESC')
            else
              Tag.all
            end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if @tag.destroy
      redirect_to admin_tags_path, notice: "タグを削除しました"
    else
      @tags = Tag.all
      flash.now[:alert] = "タグを削除できませんでした"
      render 'index'
    end
  end
end
