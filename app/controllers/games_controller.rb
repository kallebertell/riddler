class GamesController < ApplicationController

  def new
    game = session[:game] = Game.new
    game.round_count = 0
    game.save
    redirect_to :ask_question
  end


  def question
    @game = session[:game]

    if (!@game)
      redirect_to_target_or_default(root_url)
    end

    @game.round_count += 1;

    friends_statuses =
            fql(  "SELECT uid, status_id, message FROM status " +
                  "WHERE uid IN " +
                  "(SELECT uid2 FROM friend WHERE uid1 = #{@current_user.facebook_id.to_s})").
            sort_by {rand};

    status_to_guess = friends_statuses.pop()
    
    session[:correct_answer] = correct_answer = status_to_guess['uid'];

    alternative_uids = get_two_unrelated_uids(friends_statuses, correct_answer)
    alternative_uids = alternative_uids.concat([correct_answer])

    @status_message = status_to_guess['message']

    @friends = fql( "SELECT uid, name, pic_square FROM user " +
                    "WHERE uid IN (#{alternative_uids.join(', ')})").
               sort_by {rand}

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

    redirect_to :ask_question
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
