require 'test_helper'

class PixelConversionsControllerTest < ActionDispatch::IntegrationTest
  fixtures :pixels
  
  test "should create pixel conversion" do
    pixel = pixels(:one)
    impression = premium_impression

    post pixel_conversions_path(pixel), as: :json, params: {
      tracking_id: impression.id.to_s,
      test: true,
      metadata: {}
    }
    
    json = JSON.parse(response.body)
    conversion = PixelConversion.find(json["id"])
    assert_equal impression.id, conversion.impression_id
    assert conversion.test?
    assert_equal 201, status
  end
  
  test "should not create pixel conversion when tracking_id is invalid" do
    pixel = pixels(:one)
    impression = premium_impression

    post pixel_conversions_path(pixel), as: :json, params: {
      tracking_id: "foo",
      test: true
    }
    
    json = JSON.parse(response.body)
    assert_equal "Invalid Tracking ID", json["message"]
    assert_equal 404, status
  end
  
  test "should not create pixel conversion when conversion already exists" do
    pixel = pixels(:one)
    impression = premium_impression

    PixelConversion.create_from \
      pixel: pixel,
      impression: impression,
      tracking_id: impression.id.to_s,
      test: true,
      metadata: {}

    post pixel_conversions_path(pixel), as: :json, params: {
      tracking_id: impression.id,
      test: true
    }
    
    json = JSON.parse(response.body)
    assert_equal "Unable to save conversion", json["message"]
    assert_equal 422, status
  end
end
