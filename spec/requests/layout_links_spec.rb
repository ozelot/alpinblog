# -*- coding: undecided -*-
require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do
    it "should have a home page at '/" do
      get '/'
      response.should have_selector 'title', :content => "Home"
    end

    it "should have a contact page at '/contact" do
      get '/contact'
      response.should have_selector 'title', :content => "Contact"
    end

    it "should have a contact page at '/about" do
      get '/about'
      response.should have_selector 'title', :content => "About"
    end

    it "should have a contact page at '/help" do
      get '/help'
      response.should have_selector 'title', :content => "Help"
    end

    it "should have a signup page at '/signup'" do
      get '/signup'
      response.should have_selector('title', :content => "Sign up")
    end

    it "should have the correct links on the layout" do
      visit root_path
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      click_link "Home"
      response.should have_selector('title', :content => "Home")
      click_link "Sign up now!"
      response.should have_selector('title', :content => "Sign up")
    end

    describe "shadowbox" do

      before(:each) do
        @user = Factory(:user)
        @blogpost = Factory(:blogpost_with_upload, :user => @user)
      end
   
      it "should load blogpost image set up correctly" do
        get '/'
        response.should have_selector('a', :rel => "shadowbox[1]")
      end
    end
  end
  
  describe "when not logged in" do
    
    it "should have a sign in link" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Sign in")
    end
  end
  
  describe "when signed in" do
  
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email
      fill_in :password, :with => @user.password
      click_button
    end

    it"should have a sign out link" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profile")
    end

    it "should have a create post link" do
      visit root_path
      response.should have_selector("a", :href => new_blogpost_path,
                                         :content => "Create new Post!")
    end

  end
end
