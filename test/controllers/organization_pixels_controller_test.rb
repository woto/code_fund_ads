require 'test_helper'

class OrganizationPixelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get organization_pixels_index_url
    assert_response :success
  end

  test "should get show" do
    get organization_pixels_show_url
    assert_response :success
  end

end
