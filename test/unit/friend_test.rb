require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "that name is shortened correctly" do
    friend = Friend.new
    friend.name = "John Poe"
    assert friend.shortened_name == "John P"
  end

  test "that special character name is shortened correctly" do
    friend = Friend.new
    friend.name = "Örgüzh Ääliöshibütz"

    assert friend.shortened_name == "Örgüzh Ä"
  end
  
end
