Factory.define :like do |f|
  f.fb_user_id rand.to_s
  f.used_in_like_question false
  f.like_type 'interest'
  f.name 'Skiing'
end
