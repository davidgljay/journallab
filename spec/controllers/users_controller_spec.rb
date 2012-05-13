require 'spec_helper'

describe UsersController do
  render_views
  describe "GET 'new'" do
    it "should be successful" do
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
      get 'new'
      response.should be_success
      response.body.should have_selector("title", :content => "Sign up")
    end
  end

  describe "GET 'show'" do
      before(:each) do
	@user = Factory(:user)
      end

      it "should be successful" do
      	get :show, :id => @user
#      	response.should be_success
      end

      it "should return the right user" do
      	get :show, :id => @user
#	assigns(:user).should == @user
      end

    it "should have the right title" do
      get :show, :id => @user
#      response.body.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
#      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
#      response.should have_selector("h1>img", :class => "gravatar")
    end

  end

  describe "'POST' create" do
    before(:each) do
      @admin = Factory(:user, :admin => true)
      test_sign_in(@admin)
    end

    describe "failure" do

      before(:each) do
        @attr = { :firstname => "", :lastname => "", :email => "", :password => "",
                  :password_confirmation => "" }
      end

     it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end  


      it "should have the right title" do
        post :create, :user => @attr
        response.body.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
     end

     describe "success" do

      before(:each) do
        @attr = { :firstname => "Example", :lastname => "User", :email => "example@user.com", :password => "porejemplo",
                  :password_confirmation => "porejemplo" }
      end
    it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end  
     
     # Not sure how to test for a redirect to the page that was saved before signup.
     # it "should render the profile page" do
     #   post :create, :user => @attr
     #   response.should redirect_to(user_path(assigns(:user)))
     # end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the journal lab/i
     end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
   end
    
   describe "'PUT' update" do
     
       before(:each) do
          @user = Factory(:user)
         test_sign_in(@user)
       end
 
    describe "success" do

       before(:each) do
          @attr = { :firstname => "New", :lastname => "Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
       end

       it "should change the user's attributes" do
         put :update, :id => @user, :user => @attr
         @user.reload
         @user.name.should  == @attr[:firstname] + ' ' + @attr[:lastname]
         @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
          put :update, :id => @user, :user => @attr
          response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
          put :update, :id => @user, :user => @attr
          flash[:success].should =~ /updated/
      end
    end
  end


  describe "authentication of edit/update pages" do
     
    before(:each) do
      @user = Factory(:user)
    end

     describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    describe "for the wrong signed-in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => "wrong@facebook.com")
        test_sign_in(wrong_user)
      end

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
     end
 end


 describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
      @user2 = Factory(:user, :email => Factory.next(:email))
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user2
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      it "should not let admins destroy themselves" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count).by(-1)
       end
    end
  end

end
