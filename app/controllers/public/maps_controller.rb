class Public::MapsController < ApplicationController

  def index
    @maps = Map.all
    @map = Map.new
  end

  def create
    map = Map.new(map_params)
    if map.save
      redirect_to maps_path
    else
      redirect_to maps_path
    end
  end

  def destroy
    map = Map.find(params[:id])
    map.destroy
    redirect_to maps_path
  end

  private
    def map_params
      params.require(:map).permit(:address, :latitude, :longitude)
    end

end
