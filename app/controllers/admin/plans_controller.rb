class Admin::PlansController < ApplicationController

  def index
    @plans = Plan.includes(:user).where(users: { is_active: true })
  end

  def show
  end

end
