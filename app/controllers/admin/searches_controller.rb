class Admin::SearchesController < ApplicationController

  def search
    @range = params[:range]

    if @range == "ユーザー"
      @users = User.looks(params[:search], params[:word])
    elsif @range == "プラン"
      @plans = Plan.looks(params[:search], params[:word])
    end
  end

end
