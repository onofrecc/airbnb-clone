class FlatsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @flats = Flat.all
    @markers = @flats.geocoded.map do |flat|
      {
        lat: flat.latitude,
        lng: flat.longitude,
        info_window: render_to_string(partial: "info_window", locals: {flat: flat}),
        image_url: helpers.asset_url("logo.png")
      }
    end
  end

  def show
    @flat = Flat.find(params[:id])
    @booking = Booking.new
    @marker =
      {
        lat: @flat.latitude,
        lng: @flat.longitude,
        info_window: render_to_string(partial: "info_window", locals: {flat: @flat}),
        image_url: helpers.asset_url("logo.png")
      }
  end

  def new
    @flat = Flat.new
  end

  def create
    @flat = Flat.new(flat_params)
    @flat.user = current_user

    if @flat.save
      redirect_to flats_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def flat_params
    params.require(:flat).permit(:name, :description, :address, :price)
  end
end
