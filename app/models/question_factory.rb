
class QuestionFactory

  def initialize(fb_session)
    @fb_session = fb_session
  end

  def create_status_question

    question = Question.new
    
    friends_statuses = @fb_session.get_friends_statuses().sort_by {rand};

    status_to_guess = friends_statuses.pop()
    question.text = status_to_guess['message']
    correct_answer = status_to_guess['uid']
    
    possible_uids = friends_statuses.collect do |x| x['uid'] end
    possible_uids.uniq!
    possible_uids.reject! do |x| x == correct_answer end
    
    choice_uids = []
    
    3.times { choice_uids << possible_uids.pop }
    
    choice_uids = choice_uids << correct_answer

    choices_details = @fb_session.get_users_details(choice_uids).sort_by {rand}

    choices_details.each do |detail|
      choice = Choice.new
      choice.correct = correct_answer == detail['uid']
      choice.text = detail['name']
      choice.pic_url = detail['pic_square']
      choice.key = detail['uid']
      question.choices << choice
    end
    
    return question
  end




end
