class Public::PlanDetailsController < ApplicationController
  def destroy
    @plan_detail = PlanDetail.find(params[:id])
    if @plan_detail.destroy
      render json: { status: 'success' }, status: :ok
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end
end
