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
  
    describe "failure" do

      it "should not create a blogpost" do
        
      end
    end

    describe "success" do

      it "should create a blogpost" do
      
      end
    end
  end
end
