require 'test_helper'

module RicAdvert
  class Public::BannersControllerTest < ActionController::TestCase
    test "should get get" do
      get :get
      assert_response :success
    end

    test "should get click" do
      get :click
      assert_response :success
    end

  end
end
