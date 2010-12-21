Factory.define :empty_game, :class => 'Game' do |f|
  f.round_count 5
  f.after_create do |game| 
    game.user = Factory(:user)
    game.save
  end
end

Factory.define :new_game, :class => 'Game' do |f|
  f.round_count 5
  f.after_create do |game| 
    game.user = Factory(:user)
    game.save
  end
end

Factory.define :game do |f|
  f.round_count 5
  
  f.after_create do |game|
    user = Factory(:user)
    game.user = user
    game.save
  end
end

