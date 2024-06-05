class Public::PlanDetailsController < ApplicationController

  def destroy
    @plan_detail = PlanDetail.find(params[:id])
    @plan_detail.destroy
    redirect_to edit_plan_path(@plan_detail.plan)
  end

end
