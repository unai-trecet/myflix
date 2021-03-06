class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }
  
  validates :title, presence: :true, uniqueness: true
  validates :description, presence: true 

  def self.search_by_title title
  	return [] if title.blank?
      	
  	where("title LIKE ?", "%#{title}%").order("created_at DESC")
  end

end