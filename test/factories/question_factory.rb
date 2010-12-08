Factory.define :question do |f|
  f.choices { |q| 1.upto(3).map{ |i| q.association(:choice, :correct => (i==2)) }}
end
