Factory.define :game do |f|
  f.round_count 5
  f.questions { |q| 1.upto(5).map{q.association(:question) }}
  f.statuses { |s| 1.upto(10).map{s.association(:status) }}
  f.friends { |fr| 1.upto(10).map{fr.association(:friend) }}
end
