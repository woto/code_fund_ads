class GeneratePropertySparklineJob < ApplicationJob
  include CableReady::Broadcaster

  queue_as :default

  def perform(properties: nil, start_date: nil, end_date: nil, from: 0, to: 14)
    return unless properties.any?

    properties[from..to].each do |property|
      if property.impressions_count(start_date, end_date) > 0
        html = ApplicationController.new.render_to_string(SparklineComponent.new(
          values: property.sparkline_impressions(start_date, end_date),
          color: property.pending? ? "yellow" : "green"
        ))
        cable_ready["sparkline"].inner_html(selector: "#property-sparkline-#{property.id}", html: html)
        cable_ready.broadcast
      end
    end
  rescue => e
    Rails.logger.error(e)
  end
end
