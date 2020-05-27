# == Schema Information
#
# Table name: pixel_conversions
#
#  id                   :bigint           not null, primary key
#  clicked_at           :datetime
#  clicked_at_date      :date
#  country_code         :string
#  displayed_at         :datetime         not null
#  displayed_at_date    :date             not null
#  fallback_campaign    :boolean          default(FALSE), not null
#  ip_address           :string           not null
#  latitude             :decimal(, )
#  longitude            :decimal(, )
#  metadata             :jsonb            not null
#  pixel_name           :string           default(""), not null
#  pixel_value_cents    :integer          default(0), not null
#  pixel_value_currency :string           default("USD"), not null
#  postal_code          :string
#  test                 :boolean          default(FALSE)
#  user_agent           :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  advertiser_id        :bigint           not null
#  campaign_id          :bigint           not null
#  creative_id          :bigint           not null
#  impression_id        :uuid             not null
#  pixel_id             :uuid             not null
#  property_id          :bigint           not null
#  publisher_id         :bigint           not null
#  tracking_id          :string           not null
#
# Indexes
#
#  index_pixel_conversions_on_advertiser_id               (advertiser_id)
#  index_pixel_conversions_on_campaign_id                 (campaign_id)
#  index_pixel_conversions_on_clicked_at_date             (clicked_at_date)
#  index_pixel_conversions_on_clicked_at_hour             (date_trunc('hour'::text, clicked_at))
#  index_pixel_conversions_on_country_code                (country_code)
#  index_pixel_conversions_on_creative_id                 (creative_id)
#  index_pixel_conversions_on_displayed_at_date           (displayed_at_date)
#  index_pixel_conversions_on_displayed_at_hour           (date_trunc('hour'::text, displayed_at))
#  index_pixel_conversions_on_impression_id               (impression_id)
#  index_pixel_conversions_on_metadata                    (metadata) USING gin
#  index_pixel_conversions_on_pixel_id                    (pixel_id)
#  index_pixel_conversions_on_pixel_id_and_impression_id  (pixel_id,impression_id) UNIQUE
#  index_pixel_conversions_on_property_id                 (property_id)
#
class PixelConversion < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................

  # relationships .............................................................
  belongs_to :advertiser, class_name: "User", foreign_key: "advertiser_id", optional: true
  belongs_to :publisher, class_name: "User", foreign_key: "publisher_id", optional: true
  belongs_to :campaign, optional: true
  belongs_to :creative, optional: true
  belongs_to :impression, optional: true
  belongs_to :pixel
  belongs_to :property, optional: true

  # validations ...............................................................
  validates :impression_id, uniqueness: { scope: [:pixel_id], message: "already exists" }

  # callbacks .................................................................
  # scopes ....................................................................

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  monetize :pixel_value_cents, numericality: {greater_than_or_equal_to: 0}

  # class methods .............................................................
  class << self
    def create_from(pixel:, impression:, tracking_id:, test: false, metadata: nil)
      conversion = PixelConversion.new
      conversion.tracking_id = tracking_id
      conversion.test = test
      conversion.metadata = metadata || {}
      
      # Copy impression data over
      conversion.impression_id = impression.id
      conversion.advertiser_id = impression.advertiser_id
      conversion.publisher_id = impression.publisher_id
      conversion.campaign_id = impression.campaign_id
      conversion.creative_id = impression.creative_id
      conversion.property_id = impression.property_id
      conversion.ip_address = impression.ip_address
      conversion.user_agent = impression.user_agent
      conversion.country_code = impression.country_code
      conversion.postal_code = impression.postal_code
      conversion.latitude = impression.latitude
      conversion.longitude = impression.longitude
      conversion.displayed_at = impression.displayed_at
      conversion.displayed_at_date = impression.displayed_at_date
      conversion.clicked_at = impression.clicked_at
      conversion.clicked_at_date = impression.clicked_at_date
      conversion.fallback_campaign = impression.fallback_campaign

      # Copy pixel data over
      conversion.pixel_id = pixel.id
      conversion.pixel_name = pixel.name
      conversion.pixel_value = pixel.value

      conversion.save
      conversion
    end
  end

  # public instance methods ...................................................

  # protected instance methods ................................................
  protected

  # private instance methods ..................................................
  private
end
