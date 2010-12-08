Factory.define :question do |f|
  f.after_create do |f|
    f.choices { |q| 1.upto(3).map{ |i| q.association(:choice) }}
  end
end
