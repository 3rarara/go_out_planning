class Public::PlanDetailsController < ApplicationController
  def destroy
    @plan_detail = PlanDetail.find(params[:id])
    if @plan_detail.destroy
      render json: { success: true }
    else
      render json: { success: false, message: '削除に失敗しました' }
    end
  end
end
