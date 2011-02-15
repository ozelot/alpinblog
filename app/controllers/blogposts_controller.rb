class BlogpostsController < ApplicationController

  def new
    @blogpost = Blogpost.new
    @title = "Create new Post"
  end

  def create
  end

  def update
  end

  def destroy
  end

end
