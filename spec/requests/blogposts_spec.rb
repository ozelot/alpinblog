require 'spec_helper'

describe "Blogposts" do
  
  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email, :with => @user.email 
    fill_in :password, :with => @user.password
    click_button
  end
  
  describe "creation" do
    
    before(:each) do
      visit 'blogposts/new'
      @title = "The title"
      @subtitle = "The subtitle"
      @content = "The content."
    end

    describe "failure" do

      it "should not create a blogpost with empty title" do
        lambda do
          fill_in :title, :with => ""
          fill_in :subtitle, :with => @subtitle
          fill_in :content, :with => @content
          click_button
          response.should render_template('blogposts/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Blogpost, :count)
      end

      it "should not create a blogpost with empty subtitle" do
        lambda do
          fill_in :title, :with => @title
          fill_in :subtitle, :with => ""
          fill_in :content, :with => @content
          click_button
          response.should render_template('blogposts/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Blogpost, :count)
      end

      it "should not create a blogpost with empty content" do
        lambda do
          fill_in :title, :with => @title
          fill_in :subtitle, :with => @subtitle
          fill_in :content, :with => ""
          click_button
          response.should render_template('blogposts/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Blogpost, :count)
      end
    end

    describe "success" do
      
      it "should create a blogpost" do
        lambda do
          fill_in :title, :with => @title
          fill_in :subtitle, :with => @subtitle
          fill_in :content, :with => @content
          click_button
          flash[:success].should =~ /blogpost created/i
        end.should change(Blogpost, :count).by(1)
      end
    end
  end
end
