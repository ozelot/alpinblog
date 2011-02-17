class PagesController < ApplicationController
  def home
    @title = "Home"
    @blogposts = Blogpost.find(:all, :limit => 5)
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
 
  def help
    @title = "Help"
  end
end
