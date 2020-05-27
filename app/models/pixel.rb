# == Schema Information
#
# Table name: pixels
#
#  id              :uuid             not null, primary key
#  description     :text
#  name            :string           not null
#  value_cents     :integer          default(0), not null
#  value_currency  :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_pixels_on_organization_id  (organization_id)
#  index_pixels_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class Pixel < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................

  # relationships .............................................................
  belongs_to :organization
  belongs_to :user
  has_many :pixel_conversions, dependent: :destroy

  # validations ...............................................................
  validates :name, presence: true

  # callbacks .................................................................
  # scopes ....................................................................
  
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  monetize :value_cents, numericality: {greater_than_or_equal_to: 0}

  # class methods .............................................................
  class << self
  end

  # public instance methods ...................................................

  # protected instance methods ................................................
  protected

  # private instance methods ..................................................
  private
end
