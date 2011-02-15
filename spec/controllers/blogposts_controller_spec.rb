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
  end

  describe "PUT 'update'" do
  end

  describe "DELETE 'destroy'" do
  end

end
