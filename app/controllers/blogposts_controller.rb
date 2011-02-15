class BlogpostsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [:edit,:update]

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

  def edit
    @blogpost = Blogpost.find_by_id(params[:id])
    if @blogpost != nil
      @title = "Edit Blogpost"
    else
      redirect_to(root_path)
    end
  end

  def update
    @blogpost = Blogpost.find(params[:id])
    if @blogpost.update_attributes(params[:blogpost])
      flash[:success] = "Blogpost updated!"
      redirect_to blogpost_path(@blogpost)
    else
      @title = "Edit Blogpost"
      render 'edit'
    end
  end

  def show
  end

  def destroy
  end

  private
    
    def correct_user
      @blogpost = Blogpost.find_by_id(params[:id])
      if @blogpost == nil
        redirect_to(root_path)
      else
        redirect_to(root_path) unless current_user?(@blogpost.user)
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def only_visitor
      redirect_to(root_path) unless !signed_in?
    end
end
