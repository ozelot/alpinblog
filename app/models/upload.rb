class Upload < ActiveRecord::Base
  
  belongs_to :blogpost
  
  has_attached_file :image, :styles => { :thumb=> "100x100#",
                                         :medium=> "1000x1000>"}
end
