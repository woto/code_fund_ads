class PixelConversionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_pixel
  before_action :load_impression

  def create
    @conversion = PixelConversion.create_from \
      pixel: @pixel,
      impression: @impression,
      tracking_id: pixel_conversion_params[:tracking_id],
      test: pixel_conversion_params[:test],
      metadata: pixel_conversion_params[:metadata]

    if @conversion.save
      render :show, status: :created
    else
      render json: { message: "Unable to save conversion", errors: @conversion.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_pixel
    @pixel = Pixel.find_by(id: params[:pixel_id])
    render json: { message: "Invalid Pixel ID" }, status: :not_found unless @pixel
  end

  def load_impression
    @impression = Impression.find_by(id: pixel_conversion_params[:tracking_id])
    render json: { message: "Invalid Tracking ID" }, status: :not_found unless @impression
  end

  def pixel_conversion_params
    params.permit(:tracking_id, :test, metadata: {})
  end
end
