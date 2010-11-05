Factory.define :question do |f|
  f.choices { |q| 1.upto(3).map{q.association(:choice) }}
end
