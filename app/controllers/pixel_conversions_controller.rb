class PixelConversionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    CreatePixelConversionJob.perform_later pixel_conversion_params.to_h
    head :accepted
  end

  private

  def pixel_conversion_params
    params.permit(:pixel_id, :impression_id, :test, metadata: {})
  end
end
