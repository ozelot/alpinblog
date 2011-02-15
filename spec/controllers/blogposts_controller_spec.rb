require 'spec_helper'

describe BlogpostsController do
  render_views

  before(:each) do
    test_sign_in(Factory(:user))
  end

  describe "GET 'new'" do
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
