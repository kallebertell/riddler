
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
    
    choice_uids = get_two_unrelated_uids(friends_statuses, correct_answer)
    choice_uids = choice_uids.concat([correct_answer])

    @status_message = status_to_guess['message']
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


  private

  def get_two_unrelated_uids(statuses, correct_uid)
    unrelated_uids = []
    cnt = 1

    while unrelated_uids.size < 2
      uid = statuses.at(cnt)['uid']
      unrelated_uids.push(uid) if (uid != correct_uid)
      cnt += 1
    end

    unrelated_uids
  end


end
