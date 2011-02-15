require 'spec_helper'

describe BlogpostsController do
  render_views

  describe "access control" do

    it "should be denied access to create" do
      get 'new'
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'new'" do

    before(:each) do
      test_sign_in(Factory(:user))
    end

    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Create new Post")
    end

  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      @blogpost = {:title => "The Title",
                   :subtitle => "The subtitle",
                   :content => "The content."}
      test_sign_in(@user)
    end

    describe "failure" do
      
      it "should not create a blogpost with no title" do 
        lambda do
          post :create, :blogpost => @blogpost.merge(:title => "")
         end.should_not change(Blogpost, :count)
      end
      
      it "should render the home page" do
        post :create, :blogpost => @blogpost.merge(:title => "")
        response.should render_template('blogposts/new')
      end   
    end

    describe "success" do
      
      it "should create a new blogpost" do 
        lambda do
          post :create, :blogpost => @blogpost
          response.should redirect_to(root_path)
        end.should change(Blogpost, :count).by(1)
      end
    end
  end

  describe "PUT 'update'" do
  end

  describe "DELETE 'destroy'" do
  end

end
