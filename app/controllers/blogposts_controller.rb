class BlogpostsController < ApplicationController
  before_filter :authenticate

  def new
    @blogpost = Blogpost.new
    @title = "Create new Post"
  end

  def create
    @blogpost = current_user.blogposts.build(params[:blogpost])
    if @blogpost.save
      flash[:success] = "Blogpost created!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
  end

  def destroy
  end

end
