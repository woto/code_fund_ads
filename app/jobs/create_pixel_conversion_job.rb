class CreatePixelConversionJob < ApplicationJob
  queue_as :default

  def perform(params = {})
    ScoutApm::Transaction.ignore! if rand > (ENV["SCOUT_SAMPLE_RATE"] || 1).to_f

    pixel_id, impression_id, test, metadata = params.values_at(:pixel_id, :impression_id, :test, :metadata)
    Pixel.find_by(id: pixel_id)&.record_conversion impression_id, test: test, metadata: metadata
  end
end
