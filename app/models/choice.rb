class Choice < ActiveRecord::Base
  belongs_to :question

  def pic_url
    "https://graph.facebook.com/#{key}/picture"
  end
end
