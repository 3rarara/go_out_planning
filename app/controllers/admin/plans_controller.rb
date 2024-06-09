class Admin::PlansController < ApplicationController

  def index
    @plans = Plan.includes(:user).where(users: { is_active: true })
  end

  def show
    @plan = Plan.find(params[:id])
    @plan_details = @plan.plan_details
  end

end
