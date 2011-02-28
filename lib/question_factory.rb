module QuestionFactory



  private 

  def random_of(arr)
    n = arr.size
    return arr[rand(n)]
  end

  def set_random_question_attributes
    fail 'Add to game before creating' if game.nil?
    
    case(self.question_type || get_random_question_type)
    when :status
      set_status_question_attributes
    when :like
      set_like_question_attributes
    when :about
      set_about_question_attributes
    when :birthdate
      set_birthday_question_attributes
    end
  end

  def get_random_question_type
    case (rand(100))
    when 0..45: :status
    when 46..89: :like
    when 90..99: :about
    end
  end

  def set_like_question_attributes
    self.question_type = :like
    likes = Like.where(:user_id => game.user.id).order('used_at DESC NULLS LAST, random()')
    
    return set_birthday_question_attributes unless likes.count > 3 #fallback
    
    liking_to_guess = likes.pop()
    liking_to_guess.update_attribute(:used_at, Time.now)

    self.matter = liking_to_guess.name
    self.concept_of_matter = liking_to_guess.like_type
    
    correct_uids = [liking_to_guess.fb_user_id]

    not_wrong_uids = Like.where(:user_id => game.user.id, :name => self.matter).map(&:fb_user_id)
    wrong_uids = Friend.where('user_id = ? AND fb_user_id NOT IN (?)', game.user.id, not_wrong_uids).order('random()').map(&:fb_user_id).uniq[0..2]

    self.set_choices_from_correct_and_other_uids(correct_uids, wrong_uids)
  end

  def set_status_question_attributes
    self.question_type = :status
    
    statuses = Status.where(:user_id => game.user.id).order('used_at DESC NULLS LAST, random()')

    return set_birthday_question_attributes unless statuses.count > 3 #fallback
    
    status_to_guess = statuses.pop()
    status_to_guess.update_attribute(:used_at, Time.now)
    
    correct_uids = [status_to_guess.fb_user_id]
    wrong_uids = Friend.where('user_id = ? AND fb_user_id NOT IN (?)', game.user.id, correct_uids).order('random()').map(&:fb_user_id).uniq[0..2]

    self.matter = status_to_guess.message
    self.set_choices_from_correct_and_other_uids(correct_uids, wrong_uids)
  end

  def set_about_question_attributes
    self.question_type = :about
    
    friends = Friend.where('user_id = ? AND length(about) > 0', game.user.id).order('about_used_at DESC NULLS LAST, random()')

    friend_to_guess = friends.pop()

    return set_like_question_attributes if friend_to_guess.nil? #fallback

    friend_to_guess.update_attribute(:about_used_at, Time.now)

    correct_uids = [friend_to_guess.fb_user_id]
    wrong_uids = Friend.where('user_id = ? AND fb_user_id NOT IN (?)', game.user.id, correct_uids).order('random()').map(&:fb_user_id).uniq[0..2]
    
    return set_like_question_attributes if wrong_uids.length < 3 #fallback

    self.matter = friend_to_guess.about
    self.set_choices_from_correct_and_other_uids(correct_uids, wrong_uids)
    
  end

  def set_birthday_question_attributes
    self.question_type = :birthdate
    
    friends = Friend.where(:user_id => game.user.id).order('used_at DESC NULLS LAST, random()')
    
    friends.reject! do |friend| friend.birthday_date.nil? end
  
    friend_to_guess = friends.pop()
    friend_to_guess.update_attribute(:used_at, Time.now)

    self.matter = friend_to_guess.name
    correct_date = parse_fb_date( friend_to_guess.birthday_date )

    choice_dates = [correct_date]
   
    choice_dates << get_random_date_in_month_other_than(correct_date.month()) 
    
    choice_dates.each do |date| 
      choice = Choice.new
      choice.correct = correct_date.month() == date.month()
      choice.text = date.day().to_s + " " + Date::MONTHNAMES[date.month()]
      choice.key = correct_date.month().to_s
      self.choices << choice
    end
  end
  
  private 
  
  def get_random_date_in_month_other_than(month)
    rnd_month = 1 + rand(12)
    
    while (rnd_month == month) 
      rnd_month = 1 + rand(12)
    end
    
    return Date.civil(1, rnd_month, 1+rand(28))
  end
  
  def parse_fb_date(fb_birthdate)
    tokens = fb_birthdate.split("/")
    
    if (tokens.count == 2)
      return Date.civil(1, tokens[0].to_i, tokens[1].to_i)
    else
      return Date.civil(tokens[2].to_i, tokens[0].to_i, tokens[1].to_i)  
    end  
  end

  protected

  def set_choices_from_correct_and_other_uids(correct_uids, other_uids)
    Friend.where(:user_id => game.user.id, :fb_user_id => (correct_uids+other_uids)).order('random()').each do |friend|
      self.choices.build(:question_id => self.id,
                         :correct => correct_uids.include?(friend.fb_user_id),
                         :text => friend.name,
                         :pic_url => friend.pic_square_url,
                         :key => friend.fb_user_id)
    end
  end

end
