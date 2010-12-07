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
  f.statuses { |s| 1.upto(10).map{s.association(:status) }}
  f.friends { |fr| 1.upto(10).map{fr.association(:friend) }}
  f.questions { |q| 1.upto(5).map{q.association(:question) }}
end

