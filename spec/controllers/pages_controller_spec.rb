require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    # Define @base_title here
    @base_title = "Alpinfreunde | "
    @user = Factory(:user)
    @blogpost = Factory(:blogpost_with_upload, :user => @user)
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => @base_title + "Home")
    end

    it "should have a signup botton" do
      get 'home'
      response.should have_selector("a.signup_button",
                                    :content => "Sign up now!")
    end

    it "should not have a create post botton" do
      get 'home'
      response.should_not have_selector("a.create_post_button",
                                    :content => "Create new Post!")
    end

    it "should display the blogpost image" do
      get 'home'
      response.should have_selector("img", :alt => "Rails")
    end

    describe "for signed in users" do

      before(:each) do
        test_sign_in(@user)
      end

      it "should have no signup botton" do
        get 'home'
        response.should_not have_selector("a.signup_button",
                                      :content => "Sign up now!")
      end

      it "should have a create post botton" do
        get 'home'
        response.should have_selector("a.create_post_button",
                                          :content => "Create new Post!")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => @base_title + "Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => @base_title + "About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                                    :content => @base_title + "Help")
    end
  end
end
