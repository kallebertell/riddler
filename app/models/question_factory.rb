module QuestionFactory

  private 

  def set_random_question_attributes
    if (rand(2)%2 == 0)
      set_status_question_attributes
    else
      set_birthday_question_attributes
    end
  end

  def set_status_question_attributes
    self.question_type = :status
    
    friends_statuses = Status.where(:game_id => game_id).sort_by { rand }
    
    status_to_guess = friends_statuses.pop()
    self.text = status_to_guess.message
    correct_answer = status_to_guess.fb_user_id
    
    possible_uids = friends_statuses.collect do |x| x.fb_user_id end
    possible_uids.uniq!
    possible_uids.reject! do |x| x == correct_answer end
    
    choice_uids = []
    
    3.times { choice_uids << possible_uids.pop }
    
    choice_uids << correct_answer

    choices_details = Friend.where("game_id = :game_id AND fb_user_id in (:uids)",
                                   {:game_id => game_id, :uids => choice_uids})
 

    choices_details.each do |detail|
      choice = Choice.new
      choice.correct = correct_answer == detail.fb_user_id
      choice.text = detail.name
      choice.pic_url = detail.pic_square_url
      choice.key = detail.fb_user_id
      self.choices << choice
    end
  end

  def set_birthday_question_attributes
    self.question_type = :birthdate

    friends = Friend.where(:game_id => game_id).sort_by {rand}
    
    friends.reject! do |x| x.birthday_date.nil? end
  
    friend_to_guess = friends.pop()
    self.text = friend_to_guess.name
    correct_date = parse_fb_date( friend_to_guess.birthday_date )
    correct_month = correct_date.month()
    
    choice_months = [correct_month]
    
    2.times do 
      choice_months << get_random_month_other_than(correct_month)
    end
    
    choice_months.each do |month| 
      choice = Choice.new
      choice.correct = correct_month == month
      choice.text = Date::MONTHNAMES[month]
      choice.key = month.to_s
      self.choices << choice
    end
  end
  
  private 
  
  def get_random_month_other_than(month)
    rnd_month = 1 + rand(12)
    
    while (rnd_month == month) 
      rnd_month = 1 + rand(12)
    end
    
    return rnd_month
  end
  
  def parse_fb_date(fb_birthdate)
    tokens = fb_birthdate.split("/")
    
    if (tokens.count == 2)
      return Date.civil(1, tokens[0].to_i, tokens[1].to_i)
    else
      return Date.civil(tokens[2].to_i, tokens[0].to_i, tokens[1].to_i)  
    end  
  end

end
