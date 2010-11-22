
class QuestionFactory

  def initialize(fb_session, game)
    @fb_session = fb_session
    @game = game
  end

  def create_random_question
    if (rand(2)%2 == 0)
      return create_status_question
    else
      return create_birthday_question
    end
  end

  def create_status_question
    question = @game.questions.create
    question.game_id = @game.id

    question.question_type = Question::STATUS
    
    friends_statuses = @fb_session.get_friends_statuses().sort_by {rand}

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

  def create_birthday_question
    question = @game.questions.create
    question.game_id = @game.id

    question.question_type = Question::BIRTHDATE

    friends = @fb_session.get_friends_with_birthday().sort_by {rand}
    
    friends.reject! do |x| x['birthday_date'] == nil end
  
    friend_to_guess = friends.pop()
    question.text = friend_to_guess['name']
    correct_date = parse_fb_date( friend_to_guess['birthday_date'] )
    
    choice_dates = [correct_date]
    
    2.times do 
      if (rand(2)%2 == 0)
        choice_dates << correct_date + 1 + rand(10)
      else
        choice_dates << correct_date - 1 - rand(10)
      end
    end
    
    choice_dates.each do |date| 
      choice = Choice.new
      choice.correct = correct_date == date
      choice.text = date.month.to_s + "/" + date.mday.to_s
      choice.key = date.month.to_s + "_" + date.mday.to_s
      question.choices << choice
    end
    
    return question
  end
  
  private 
  
  def parse_fb_date(fb_birthdate)
    tokens = fb_birthdate.split("/")
    
    if (tokens.count == 2)
      return Date.civil(1, tokens[0].to_i, tokens[1].to_i)
    else
      return Date.civil(tokens[2].to_i, tokens[0].to_i, tokens[1].to_i)  
    end  
  end

end
