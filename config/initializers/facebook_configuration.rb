if Rails.env == 'production'
  FB_APP_ID = '150102758358340'
  FB_API_KEY = 'cc1cff344718fa271871ccc62cef7dc5'
  FB_SECRET = 'a12e1de81a7917a5f670ae48c282fb98'
  FB_APP_ROOT = 'http://apps.facebook.com/friddler/'
else
  FB_APP_ID = '166590666700460'
  FB_API_KEY = '0b7b13df63e3a6daccb0300e091e249d'
  FB_SECRET = '6b4eb36e6fe710eebc534befbff7ccdc'
  FB_APP_ROOT = 'http://apps.facebook.com/thelocalhost/'
end
