require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get connect4" do
    get :connect4
    assert_response :success
  end

end
