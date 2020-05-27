require 'test_helper'

class PixelConversionsControllerTest < ActionDispatch::IntegrationTest
  fixtures :pixels
  
  test "should create pixel conversion" do
    pixel = pixels(:one)
    impression = premium_impression
    post pixel_conversions_path(pixel), params: {
      legacy_id: impression.id.to_s,
      test: true
    }
    
    assert_equal 200, status
    puts response.body
  end
end
