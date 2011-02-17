require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do
      
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name" => ""
          fill_in "Email" => ""
          fill_in "Password" => ""
          fill_in "Confirmation" => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
      
      it "should clear the password fields" do
        lambda do
          visit signup_path
          fill_in "Name" => ""
          fill_in "Email" => ""
          fill_in "Password", :with => "foobar"
          fill_in "Confirmation", :with => "invalid"
          click_button
          response.should render_template('users/new')
          response.should have_selector("input[name='user[password]'][type='password']", :content => "")
          response.should have_selector("input[name='user[password_confirmation]'][type='password']", :content => "")
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name", :with => "Andreas"
          fill_in "Email", :with => "stehling.andreas@gmail.com"
          fill_in "Password", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should render_template('users/new')
          response.should_not have_selector("div#error_explanation")
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in / out" do

    describe "failure" do
      
      it "should not sign in a user" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should  sign in a user" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link("Sign out")
        controller.should_not be_signed_in
      end
    end
  end

  describe "layout links in 'show'" do

    before(:each) do
      @user = Factory(:user)
      @blogpost = Factory(:blogpost, :user => @user)
    end

    describe "for not-signed-in users" do

      it "should have a correct [...] link" do
        visit user_path(@user)
        click_link("[...]")
        response.should render_template('blogposts/show')
      end
    end

    describe "for authorized users" do

      before(:each) do
        integration_sign_in(@user)
      end

      it "should have a correct [...] link" do
        visit user_path(@user)
        click_link("[...]")
        response.should render_template('blogposts/show')
      end

      it "should have a correct edit link" do
        visit user_path(@user)
        click_link("edit")
        response.should render_template('blogposts/edit')
      end

      it "should have a correct delete link" do
        visit user_path(@user)
        click_link("delete")
        # dont know how to test confirm on click "delete"
        # click_link("delete", :confirm => true)
      end
    end
  end
end

