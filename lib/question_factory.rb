module QuestionFactory



  private 

  def random_of(arr)
    n = arr.size
    return arr[rand(n)]
  end

  def set_random_question_attributes
    fail 'Add to game before creating' if game_id.nil?
    self.question_type ||= random_of(self.question_types)
    
    case self.question_type
    when :status
      set_status_question_attributes
    when :birthdate
      set_birthday_question_attributes
    when :like
      set_like_question_attributes
    end
  end

  def set_like_question_attributes
    likes = Like.where(:game_id => game_id, :used_in_like_question => false).sort_by { rand }

    # Change to other question type if the user has too little likes
    return set_birthday_question_attributes unless likes.count > 3
    
    liking_to_guess = likes.pop()
    liking_to_guess.update_attribute(:used_in_like_question, true)
    self.matter = liking_to_guess.name
    self.concept_of_matter = liking_to_guess.like_type
    
    correct_uids = [liking_to_guess.fb_user_id]
    wrong_uids = likes.select { |fl|
                         !correct_uids.include?(fl) and
                         Like.where(:fb_user_id => fl.fb_user_id,
                                    :name => self.matter).empty?
                       }.map(&:fb_user_id).uniq[0..2]

    self.set_choices_from_correct_and_other_uids(correct_uids, wrong_uids)
  end

  def set_status_question_attributes
    statuses = Status.where(:game_id => game_id, :used_in_status_question => false).sort_by { rand }

    # Change to other question type if the user has too little statuses
    return set_birthday_question_attributes unless statuses.count > 3
    
    status_to_guess = statuses.pop()
    status_to_guess.update_attribute(:used_in_status_question, true)
    
    correct_uids = [status_to_guess.fb_user_id]
    wrong_uids = statuses.map(&:fb_user_id).uniq.reject { |fs| correct_uids.include?(fs) }[0..2]

    self.matter = status_to_guess.message
    self.set_choices_from_correct_and_other_uids(correct_uids, wrong_uids)
  end

  def set_birthday_question_attributes
    friends = Friend.where("game_id = :game_id AND used_in_birthday_question = false",
                           {:game_id => game_id}).
                           sort_by {rand}
    
    friends.reject! do |x| x.birthday_date.nil? end
  
    friend_to_guess = friends.pop()
    friend_to_guess.used_in_birthday_question = true
    friend_to_guess.save()
    
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

  protected

  def set_choices_from_correct_and_other_uids(correct_uids, other_uids)
   Friend.where(:game_id => game_id, :fb_user_id => (correct_uids+other_uids)).sort { rand }.map do |friend|
     self.choices.build( :question_id => self.id,
                          :correct => correct_uids.include?(friend.fb_user_id),
                          :text => friend.name,
                          :pic_url => friend.pic_square_url,
                          :key => friend.fb_user_id)
   end
   # choices_attributes = 
   #   Friend.where(:game_id => game_id, :fb_user_id => (correct_uids+other_uids)).map do |friend|
   #     [self.id,
   #      correct_uids.include?(friend.fb_user_id),
   #      friend.name,
   #      friend.pic_square_url,
   #      friend.fb_user_id]
   #   end.sort { rand }
   # Choice.mass_insert(%w(question_id correct text pic_url key), choices_attributes)
  end

end
