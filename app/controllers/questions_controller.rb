class QuestionsController < ApplicationController

  def new
    @game = session[:game]

    if (!@game)
      redirect_to_target_or_default(root_url)
    end

    @game.round_count += 1;

    friends_statuses = @fb_session.get_friends_statuses().sort_by {rand};

    status_to_guess = friends_statuses.pop()
    
    session[:correct_answer] = correct_answer = status_to_guess['uid'];

    choice_uids = get_two_unrelated_uids(friends_statuses, correct_answer)
    choice_uids = choice_uids.concat([correct_answer])

    @status_message = status_to_guess['message']

    @friends = @fb_session.get_users_details(choice_uids).sort_by {rand}

    for friend in @friends
      session[:correct_answer_metadata] = friend if (friend['uid'] == correct_answer)
    end

  end

  def answer

    if (params[:answer].to_s == session[:correct_answer].to_s)
      flash[:correct] = "Correct!"
    else
      flash[:incorrect] = "Incorrect. Should've been "+session[:correct_answer_metadata]['name']
    end

    redirect_to :new_question
  end

  
  private

  def get_two_unrelated_uids(statuses, correct_uid)
    unrelated_uids = []
    cnt = 1;

    while unrelated_uids.size < 2
      uid = statuses.at(cnt)['uid']
      unrelated_uids.push(uid) if (uid != correct_uid)
      cnt += 1;
      break if (cnt > 999)
    end

    unrelated_uids
  end

end
