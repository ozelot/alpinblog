class Upload < ActiveRecord::Base
  
  belongs_to :blogpost
  
  has_attached_file :image, :styles => { :thumb=> "100x100#"}
end
