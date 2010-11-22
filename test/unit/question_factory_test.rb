require 'test_helper'

class QuestionFactoryTest < ActiveSupport::TestCase

  def setup
    @game = Factory(:game)
    @fb_session = mock()
    @question_factory = QuestionFactory.new(@fb_session, @game)
  end

  test "should build question of type status" do
    @fb_session.expects(:get_friends_statuses).
                returns([ {'message'=>'foo1', 'uid'=>123},
                          {'message'=>'foo2', 'uid'=>124},
                          {'message'=>'foo3', 'uid'=>125},
                          {'message'=>'foo4', 'uid'=>126} ])
                          
    @fb_session.expects(:get_users_details).
                returns([ {'uid' => 123, 'pic_square'=>'http://pic.com/foo1', 'name'=>'John1'},
                          {'uid' => 124, 'pic_square'=>'http://pic.com/foo2', 'name'=>'John2'},
                          {'uid' => 125, 'pic_square'=>'http://pic.com/foo3', 'name'=>'John3'},
                          {'uid' => 126, 'pic_square'=>'http://pic.com/foo4', 'name'=>'John4'} ])
                      
    # @fb_session.get_friends_statuses()
    # @fb_session.get_users_details(choice_uids)
  
    status_question = @question_factory.create_status_question()
    assert_equal Question::STATUS, status_question.question_type    
  end

end
