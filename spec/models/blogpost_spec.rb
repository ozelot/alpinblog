require 'spec_helper'

describe Blogpost do

  before(:each) do
    @user = Factory(:user)
    @attr = {:title => "The title",
             :subtitle => "This it the subtitle",
             :content => "This is the content."}
  end

  it "should create a new instance" do
    @user.blogposts.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @blogpost = @user.blogposts.create!(@attr)
    end
    
    it "should have a user attribute" do
      @blogpost.should respond_to(:user)
    end

    it "should belong to the right user" do
      @blogpost.user_id.should == @user.id
      @blogpost.user.should == @user
    end
  end

  describe "validations" do
    
    it "should require a user attribute" do
      Blogpost.new(@attr).should_not be_valid
    end

    it "should require a non-empty title" do
      @user.blogposts.build(:title => "").should_not be_valid
    end

    it "should require a non-empty subtitle" do
      @user.blogposts.build(:subtitle => "").should_not be_valid
    end

    it "should require a non-empty content" do
      @user.blogposts.build(:content => "").should_not be_valid
    end

    it "should reject too long title" do
      @user.blogposts.build(:title => "a"*50).should_not be_valid
    end

    it "should reject too long subtitle" do
      @user.blogposts.build(:subtitle => "a"*100).should_not be_valid
    end

    it "should reject too long content" do
      @user.blogposts.build(:content => "a"*2000).should_not be_valid
    end
  end
end
