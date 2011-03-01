class Blogpost < ActiveRecord::Base
  attr_accessible :title, :subtitle, :content, :photo

  belongs_to :user

  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>" }

  default_scope :order => 'blogposts.created_at DESC'

  validates :user_id, :presence => true
  validates :title, :presence => true,
                    :length => {:maximum => 50}
  validates :subtitle, :presence => true,
                       :length => {:maximum => 100}
  validates :content, :presence => true,
                      :length => {:maximum => 2000}
end
