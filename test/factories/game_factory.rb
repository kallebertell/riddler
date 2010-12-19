Factory.define :empty_game, :class => 'Game' do |f|
  f.round_count 5
end

Factory.define :new_game, :class => 'Game' do |f|
  f.round_count 5
  f.statuses { |s| 1.upto(10).map{s.association(:status) }}
  f.friends { |fr| 1.upto(10).map{fr.association(:friend) }}
end

Factory.define :game do |f|
  f.round_count 5
  f.after_create do |game|
    interests = %w(Eating Sleeping Dancing)

    100.upto(105).each do |rand_id|
      fb_id = rand_id.to_s
      Factory(:friend, :fb_user_id => fb_id, :game_id => game.id)
      Factory(:status, :fb_user_id => fb_id, :game_id => game.id)
      Factory(:like, :fb_user_id => fb_id, :game_id => game.id, :name => interests[rand_id % 3])
    end

    5.times do
      game.questions.create
    end
  end
end

