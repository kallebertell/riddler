Factory.define :game do |f|
  f.round_count 5
    f.questions { |q| 1.upto(5).map{q.association(:question) }}
end
