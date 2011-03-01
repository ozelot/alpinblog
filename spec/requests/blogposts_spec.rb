require 'spec_helper'

describe "Blogposts" do

  describe "creation" do
    
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with => @user.email 
      fill_in :password, :with => @user.password
      click_button
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

      it "should not create a blogpost with not existing upload file" do
        lambda do
          fill_in :title, :with => @title
          fill_in :subtitle, :with => @subtitle
          fill_in :content, :with => @content
          fill_in :blogpost_photo, :with => "path/to/not/existing/file.png"
          click_button
        end.should raise_error
      end
    end

    describe "success" do
      
      it "should create a blogpost" do
        lambda do
          fill_in :title, :with => @title
          fill_in :subtitle, :with => @subtitle
          fill_in :content, :with => @content
          fill_in :blogpost_photo, :with => "spec/fixtures/images/rails.png"
          click_button
          flash[:success].should =~ /blogpost created/i
        end.should change(Blogpost, :count).by(1)
      end
    end
  end

  describe "layout links" do

    before(:each) do
      @user = Factory(:user)
      @blogpost = Factory(:blogpost, :user => @user)
    end

    describe "for not signed-in users" do

      it "should not have a delete and edit link on home page" do
        visit root_path
        response.should_not have_selector("a", :content => "edit")
        response.should_not have_selector("a", :content => "delete")
        click_link("[...]")
        response.should_not have_selector("a", :content => "edit")
        response.should_not have_selector("a", :content => "delete")
      end

      it "should not have a delete and edit link on blogpost show page" do
        visit root_path
        click_link("[...]")
        response.should_not have_selector("a", :content => "edit")
        response.should_not have_selector("a", :content => "delete")
      end
    end

    describe "for authorized users" do

      before(:each) do
        integration_sign_in(@user)
        visit root_path
      end

      it "should have a delete and edit link on home page" do
        response.should have_selector("a", :content => "edit")
        response.should have_selector("a", :content => "delete")
      end

      it "should have a delete and edit link on blogpost show page" do
        click_link("[...]")
        response.should have_selector("a", :content => "edit")
        response.should have_selector("a", :content => "delete")
      end

      it "should have correct edit link on blogposts show page" do
        click_link("[...]")
        click_link("edit")
        response.should render_template('blogposts/edit')
      end

      it "should have correct delete link" do
        click_link("[...]")
        click_link("delete")
        # dont know how to test confirm on click "delete"
        # click_link("delete", :confirm => true)
      end
    end
  end
end
