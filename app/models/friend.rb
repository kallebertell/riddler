class Friend < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :statuses
  
  scope :expired_since, lambda {|time| where("expire_at < ?", time) }
  
  def shortened_name
    split_name = self.name.split(' ')
    
    return split_name[0] if split_name.length < 2
    
    split_name[0] + " " + split_name[split_name.length-1][0,1]
  end

end
