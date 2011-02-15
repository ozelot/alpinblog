class Blogpost < ActiveRecord::Base
  attr_accessible :title, :subtitle, :content

  belongs_to :user

  default_scope :order => 'blogposts.created_at DESC'

  validates :user_id, :presence => true
  validates :title, :presence => true,
                    :length => {:maximum => 50}
  validates :subtitle, :presence => true,
                       :length => {:maximum => 100}
  validates :content, :presence => true,
                      :length => {:maximum => 2000}
end
