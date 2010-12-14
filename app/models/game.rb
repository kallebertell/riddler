class Game < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  has_many :questions
  has_many :friends
  has_many :statuses
  has_many :likes
  belongs_to :user

  after_create :set_cached_facebook_data_for_game
  attr_writer :facebook_data

  def rounds_left?
    round_count > questions.count
  end

  def points
    questions.reduce(0) do |sum, question|
      if question.answered_correctly?
        sum + 1
      else
        sum
      end
    end
  end

  private

  def set_cached_facebook_data_for_game
    return unless @facebook_data
    @init = Time.now.to_f
    data = @facebook_data
    p ['0CLOCK',(Time.now.to_f-@init)]
    
    status_datas = data['statuses']
    friend_datas = data['friends']
  
    p ['1CLOCK',(Time.now.to_f-@init)]
    Friend.mass_insert(%w(game_id fb_user_id name pic_square_url birthday_date), 
                  friend_datas.map { |friend_data| 
                    [self.id,
                     friend_data['uid'],
                     friend_data['name'],
                     friend_data['pic_square'],
                     friend_data['birthday_date']] 
                  })
    p ['2CLOCK',(Time.now.to_f-@init)]
    Status.mass_insert(%w(game_id fb_user_id fb_status_id message),
                  status_datas.map { |status_data|
                    [self.id,
                     status_data['uid'],
                     status_data['status_id'],
                     truncate(status_data['message'], :length => 255, :omission=> '...')] })
    p ['3CLOCK',(Time.now.to_f-@init)]
    like_attributes = []
    friend_datas.each do |friend_data|
      { :interests => friend_data['interests'],
        :books => friend_data['books'],
        :tv => friend_data['tv'],
        :movies => friend_data['movies'],
        :activities => friend_data['activities'],
        :music => friend_data['music']
      }.map do |key, values|
        values.split(',').map(&:strip).reject(&:blank?).each do |name|
          like_attributes << [self.id, key.to_s.singularize, name, friend_data['uid']]
        end unless values.blank?
      end
    end
    p ['4CLOCK',(Time.now.to_f-@init)]
    Like.mass_insert(%w(game_id like_type name fb_user_id), like_attributes)
    p ['5LOCK',(Time.now.to_f-@init)]
    
  end

end
