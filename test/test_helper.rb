ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'
require 'data/facebook_response'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...


  def login_as(user, &block)
    raise 'please give block' unless block_given?
    mocked_session = mock()
    mocked_session.stubs(:fetch_game_data).then.returns(FRIEND_MOCK_DATA)
    
    ApplicationController.send(:define_method, :session) do
      @session_cache ||= { :user_id => user.facebook_id, :fb_session => mocked_session }
    end
    yield user
  ensure
    ApplicationController.remove_possible_method(:session)
  end
end
