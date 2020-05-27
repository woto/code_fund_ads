class CreatePixelConversions < ActiveRecord::Migration[6.0]
  def change
    create_table :pixel_conversions do |t|
      t.uuid :pixel_id, null: false
      t.uuid :impression_id, null: false
      t.string :tracking_id, null: false
      t.boolean :test, default: false
      t.string :pixel_name, null: false, default: ""
      t.monetize :pixel_value, default: Money.new(0, "USD"), null: false
      t.bigint :advertiser_id, null: false
      t.bigint :publisher_id, null: false
      t.bigint :campaign_id, null: false
      t.bigint :creative_id, null: false
      t.bigint :property_id, null: false
      t.string :ip_address, null: false
      t.text :user_agent, null: false
      t.string :country_code
      t.string :postal_code
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :displayed_at, default: "now()", null: false
      t.date :displayed_at_date, default: "now()::date", null: false
      t.datetime :clicked_at
      t.date :clicked_at_date
      t.boolean :fallback_campaign, default: false, null: false
      t.jsonb :metadata, null: false, default: '{}'

      t.index [:pixel_id, :impression_id], unique: true
      t.index :pixel_id
      t.index :impression_id
      t.index :advertiser_id
      t.index :campaign_id
      t.index :creative_id
      t.index :property_id
      t.index :country_code
      t.index :displayed_at_date
      t.index "date_trunc('hour', displayed_at)", name: "index_pixel_conversions_on_displayed_at_hour"
      t.index :clicked_at_date
      t.index "date_trunc('hour', clicked_at)", name: "index_pixel_conversions_on_clicked_at_hour"
      t.index :metadata, using: :gin

      t.timestamps
    end
  end
end
