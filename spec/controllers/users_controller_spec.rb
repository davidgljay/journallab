require 'spec_helper'

describe UsersController do
  render_views

 describe 'Subscription Management' do
   before(:each) do
     @user = create(:user)
   end

   it "should set the user's subscriptions" do
     test_sign_in(@user)
     put :set_subscriptions, {"user"=>{"weekly"=>"1", "alerts"=>"1", "reply"=>"0", "jclub"=>"1", "impact"=>"1", "author"=>"0", "milestone"=>"1"}}
     @user.reload
     @user.receive_mail?("jclub").should be_true
     @user.receive_mail?('author').should be_false

   end
end

 describe "DELETE 'destroy'" do

    before(:each) do
      @user = create(:user)
      @user2 = create(:user)
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
        @admin = create(:user, :email => "admin@example.com", :admin => true)
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
