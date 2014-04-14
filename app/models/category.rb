class Category < ActiveRecord::Base 
  has_many :videos

  validates_presence_of :name

  def recent_videos
  	videos.order('created_at DESC').take(6)
  end
end