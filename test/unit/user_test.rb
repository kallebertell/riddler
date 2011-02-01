require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = Factory(:user_with_user_friends)
  end

  test "should find user friends" do
    assert_not_nil @user.id
    user_friends = User.find_user_and_friends(@user.id)
    assert_equal 5, user_friends.size
  
  end
  
end
