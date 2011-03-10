require 'spec_helper'

describe BlogpostsController do
  render_views

  describe "access control" do

    describe "not signed-in users" do

      it "should be denied access to new page" do
        get :new
        response.should redirect_to(signin_path)
      end
      
      it "should be denied access to resource creation" do
        post :create
        response.should redirect_to(signin_path)
      end
      
      it "should be denied access to resource edit page" do
        get :edit, :id => 1
        response.should redirect_to(signin_path)
      end
      
      it "should be denied access to resource update" do
        put :update, :id => 1
        response.should redirect_to(signin_path)
      end
      
      it "should be denied access to resource deletion" do
        delete :destroy, :id => 1
        response.should redirect_to(signin_path)
      end
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

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @blogpost = Factory(:blogpost_with_upload, :user => @user)
    end

    it "should be successful" do
      get :show, :id => @blogpost
      response.should be_success
    end

    it "should render the show page" do
      post :show, :id => @blogpost
      response.should render_template('blogposts/show')
    end

    it "should have the right title" do
      get :show, :id => 1
      response.should have_selector("title", :content => "Blogpost")
    end

    it "should display the correct image" do
      get :show, :id => 1
      response.should have_selector("img", :alt => "Rails")
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      @blogpost = {:title => "The Title",
        :subtitle => "The subtitle",
        :content => "The content.",
        :uploads_attributes => { :image => { :image_file_name => "spec/fixtures/images/rails.png"} }
      }
    end

    describe "failure" do

      it "should not create a blogpost with no title" do 
        lambda do
          post :create, :blogpost => @blogpost.merge(:title => "")
         end.should_not change(Blogpost, :count)
      end
      
      it "should render the new page" do
        post :create, :blogpost => @blogpost.merge(:title => "")
        response.should render_template('blogposts/new')
      end   

      it "should render the new page" do
        post :create, :blogpost => @blogpost.merge(:subtitle => "")
        response.should render_template('blogposts/new')
      end

      it "should render the new page" do
        post :create, :blogpost => @blogpost.merge(:content => "")
        response.should render_template('blogposts/new')
      end
    end

    describe "success" do

      it "should create a new blogpost" do 
        lambda do
          post :create, :blogpost => @blogpost
          response.should render_template('show')
        end.should change(Blogpost, :count).by(1)
      end
      
      it "should display the correct blogpost image" do
        post :create, :blogpost => @blogpost
        response.should have_selector("img", :alt => "Rails")
      end
    end
  end

  describe "GET 'edit'" do

    describe "success" do
    
      before(:each) do
        @user = Factory(:user)
        @blogpost = Factory(:blogpost_with_upload, :user => @user)
        test_sign_in(@user)
      end
    
      it "should be successful" do
        get :edit, :id => @blogpost
        response.should be_success
      end
      
      it "should have the right title" do
        get :edit, :id => @blogpost
        response.should have_selector("title", :content => "Edit Blogpost")
      end

      it "should diplay image and remove box" do
        get :edit, :id => @blogpost
        response.should have_selector("img", :alt => "Rails")
        response.should have_selector("input" , :name => "blogpost[uploads_attributes][0][id]")
      end
    end

    describe "authentication" do

      before(:each) do
        @user = Factory(:user)
        @blogpost = Factory(:blogpost, :user => @user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
      end

      it "should deny access" do
        get :edit, :id => @blogpost
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      @blogpost = Factory(:blogpost_with_upload, :user => @user)
    end

    describe "failure" do
      
      before(:each) do
        test_sign_in(@user)
        @attr = Factory.attributes_for(:blogpost).merge(:uploads_attributes => { :image => { :image_file_name => "spec/fixtures/images/rails.png"} })
      end

      it "should render the update template for empty title" do
        put :update, :id => @blogpost, :blogpost => @attr.merge(:title => "")
        response.should render_template('edit')
      end

      it "should render the update template for empty subtitle" do
        put :update, :id => @blogpost, :blogpost => @attr.merge(:subtitle => "")
        response.should render_template('edit')
      end

      it "should render the update template for empty content" do
        put :update, :id => @blogpost, :blogpost => @attr.merge(:content => "")
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @blogpost, :blogpost => @attr.merge(:content => "")
        response.should have_selector("title", :content => "Edit Blogpost")
      end
    end

    describe "success" do

      before(:each) do
        test_sign_in(@user)
        @attr = Factory.attributes_for(:blogpost).merge(:uploads_attributes => { :image => { :image_file_name => "spec/fixtures/images/rails2.png"} }).merge(:title => "foo")
      end

      it "should update the post" do
        put :update, :id => @blogpost, :blogpost => @attr
        flash[:success].should =~ /Blogpost updated/i
        @blogpost.reload
        @blogpost.title.should == @attr[:title]
        @blogpost.subtitle.should == @attr[:subtitle]
        @blogpost.content.should == @attr[:content]
        response.should redirect_to(blogpost_path(@blogpost))
      end

      it "should add the second image" do
        lambda do
          put :update, :id => @blogpost, :blogpost => @attr
        end.should change(Upload, :count).by(1)
      end

      it "should remove the image" do
        lambda do
          put :update, :id => @blogpost, :blogpost => @attr.merge(:uploads_attributes => {:image => { :id => @blogpost.uploads[0].id, :_destroy=> 1 }})
        end.should change(Upload, :count).by(-1)
      end
    end

    describe "authentication" do
    
      describe "for signed-in users" do

        before(:each) do
          wrong_user = Factory(:user, :email => Factory.next(:email))
          test_sign_in(wrong_user)
        end
      
        it "it should deny access" do
          put :update, :id => @blogpost
          response.should redirect_to(root_path)
        end
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
      @blogpost = Factory(:blogpost_with_upload, :user => @user)
    end

    describe "failure" do
    end

    describe "success" do

      before(:each) do
        test_sign_in(@user)
      end
     
      it "should delete the blogpost" do
        lambda do
          delete :destroy, :id => @blogpost
          flash[:success].should =~ /Blogpost deleted/i
          response.should redirect_to(user_path(@user))
        end.should change(Blogpost, :count).by(-1) && change(Upload, :count).by(-1)
      end
    end

    describe "authentication" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
      end

      it "should deny access" do
        delete :destroy, :id => @blogpost
        response.should redirect_to(root_path)
      end 
    end
  end
end
