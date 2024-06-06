class ApplicationController < ActionController::Base

  def route_not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
