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
  
  test "should find user friends ordered by week score" do
    user_friends = User.find_user_and_friends_ordered_by_week_score(@user.id)
    assert_equal 5, user_friends.size
    
    1.upto(5).each { |x| assert_equal x, user_friends[x-1].rank}
  end
  
end
