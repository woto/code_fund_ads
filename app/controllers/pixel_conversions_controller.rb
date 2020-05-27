class PixelConversionsController < ApplicationController
  before_action :load_pixel
  before_action :load_impression

  def create
    @conversion = @pixel.pixel_conversions.build
    @conversion.tracking_id = pixel_conversion_params[:tracking_id]
    @conversion.test = pixel_conversion_params[:test] == "true"
    @conversion.metadata = pixel_conversion_params[:metadata]
    
    # Copy impression data over
    @conversion.impression_id = @impression.impression_id
    @conversion.advertiser_id = @impression.advertiser_id
    @conversion.publisher_id = @impression.publisher_id
    @conversion.campaign_id = @impression.campaign_id
    @conversion.creative_id = @impression.creative_id
    @conversion.property_id = @impression.property_id
    @conversion.campaign_name = @impression.campaign_name
    @conversion.property_name = @impression.property_name
    @conversion.ip_address = @impression.ip_address
    @conversion.user_agent = @impression.user_agent
    @conversion.country_code = @impression.country_code
    @conversion.postal_code = @impression.postal_code
    @conversion.latitude = @impression.latitude
    @conversion.longitude = @impression.longitude
    @conversion.displayed_at = @impression.displayed_at
    @conversion.displayed_at_date = @impression.displayed_at_date
    @conversion.clicked_at = @impression.clicked_at
    @conversion.clicked_at_date = @impression.clicked_at_date
    @conversion.fallback_campaign = @impression.fallback_campaign

    # Copy pixel data over
    @conversion.pixel_id = @pixel.pixel_id
    @conversion.pixel_name = @pixel.pixel_name
    @conversion.pixel_value = @pixel.pixel_value

    @conversion.save

    respond_to do |format|
      format.html do
        render plain: "OK", status: :created if @conversion.persisted?
        render plain: "Error", status: :created unless @conversion.persisted?
      end
      format.json do
        render :show, status: :created, location: @conversion if @conversion.persisted?
        render json: @conversion.errors, status: :unprocessable_entity unless @conversion.persisted?
      end
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
