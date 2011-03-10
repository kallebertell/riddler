Factory.define :user do |f|
  f_id = (100000 + rand(100000)).to_s
  f.facebook_id f_id
  f.name 'example user'
  f.games_left 3
  
  interests = ['Eating', 'Sleeping', 'Dancing', 'Ice-Hockey', 'cycling']
  
  f.after_create do |user|
    100.upto(105).each do |rand_id|
      fb_id = rand_id.to_s
      Factory(:friend, :fb_user_id => fb_id, :user_id => user.id, :birthday_date => "10/10")
      Factory(:status, :fb_user_id => fb_id, :user_id => user.id, :message => "this is my status update") 
      Factory(:like, :fb_user_id => fb_id, :user_id => user.id, :like_type => "movie", :name => interests[rand_id % 5])
    end
  end
  
end

Factory.define :user_with_user_friends, :class => 'User' do |f|
  f_id = (100000 + rand(100000)).to_s
  f.facebook_id f_id
  f.name 'user with friends'
  f.score_recorded_at 7.days.ago
  f.week_best_score 99999
  
  f.after_create do |user|
    200.upto(203).each do |fb_id|
      
      user_friend = Factory(:user, :facebook_id => fb_id, :week_best_score => fb_id*10, :score_recorded_at => Time.now)
      friend = Factory(:friend, :user_id => user.id, :fb_user_id => fb_id)
    end
  end
  
end

