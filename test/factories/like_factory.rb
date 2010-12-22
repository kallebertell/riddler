Factory.define :like do |f|
  f.fb_user_id rand.to_s
  f.like_type 'interest'
  f.name 'Skiing'
end
