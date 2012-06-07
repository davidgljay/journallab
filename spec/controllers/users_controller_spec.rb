require 'spec_helper'

describe UsersController do
  render_views

 describe "unsubscribe" do

   before(:each) do
      	@user = Factory(:user)
	test_sign_in(@user)
   end

   it "should unsubscribe the user" do
	get :unsubscribe, :id => @user.id
	@user.subscriptions.count.should == 1
	@user.receive_mail?.should == false
   end

   it "should switch the user to daily digest" do
	get :share_digest, :id => @user.id
	@user.subscriptions.count.should == 2
	@user.receive_mail?.should == true
	@user.receive_mail?("share_notification").should == false
	@user.subscriptions.select{|s| s.category == "share_digest" && s.receive_mail == true}.count.should == 1
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
      #  response.should redirect_to(signin_path)
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
