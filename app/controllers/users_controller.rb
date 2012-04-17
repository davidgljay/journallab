class UsersController < ApplicationController
before_filter :authenticate, :except => [:new, :create]
before_filter :correct_user, :only => [:edit, :update, :unsubscribe, :image_upload]
before_filter :admin_user,   :only => [:create, :new, :destroy]
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
   @user = User.find(params[:id])
   @title = @user.name
   @recent_visits = @user.visited_papers.reverse.uniq.first(20)
   @recent_activity = @user.recent_activity
  end

  def new
   @title = "Sign up users"
   @user = User.new
   @groups = Group.all
  end

  def unsubscribe
   User.find(params[:id]).unsubscribe
  end

  def reset_password
   @title = "Reset User Password"
   if params[:email] != nil
     @user = User.find_by_email(params[:email])
     if @password = current_user.reset_user_password(@user)
      flash[:success] = @user.name + "'s password has been reset to " + @password
     else
       flash[:error] = "You must be an admin, how did you get here?"
     end
   end
   render 'reset_password'
  end

  def  bulk_new
   @title = "Bulk user signup"
   @users = []
   10.times do
     @users << User.new()
   end
   @groups = Group.all 
  end

  def bulk_create
   @title = "Users added!"
   @group = Group.find(params['group_id'])
   firstnames = params['firstnames']
   @passwords = []
   @users = []
   firstnames.length.times do |i|
     u = User.new({:firstname => firstnames[i], :lastname => params['lastnames'][i], :email => params['emails'][i]})
      password = (u.colors[rand(current_user.colors.length - 1)] + u.colors[rand(current_user.colors.length - 1)] + rand(100).to_s).gsub(/[ ]/, '_')
      u.email.downcase!
      u.password = password
      u.password_confirmation = password
      u.generate_anon_name
      if u.save
        @passwords << password
        @group.users << u
        @users << u
      else
        @users << u
        @passwords << u.errors
      end       
    end
   render 'bulk_confirmation'
   end

  def create
   @user = User.new(params[:user])
   @user.generate_anon_name
   msg = ""
   @user.email.downcase!
   if @user.save
      sign_in @user
      url = root_path
      unless params[:group_id].nil? 
        @group = Group.find(params[:group_id])
        @user.groups << Group.find(params[:group_id])
        msg = "You've been added to " + @group.name
        url = @group
      end
      flash[:success] = "Welcome to the Journal Lab!" + msg
      redirect_back_or root_path
   elsif @user.errors[:anon_name] == ["has already been taken"]
     10.times do 
      @user.generate_anon_name
      @user.save
     end
   else
     @title = "Sign up"
     @groups = Group.all
     render "new"
   end
  end

  def edit
   @title = "Edit user"
  end 

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
    end
      redirect_to @user
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
       flash[:success]="You may not destroy another administrator."
       redirect_to users_path
    else
      User.find(params[:id]).destroy
      flash[:success]="User destroyed."
      redirect_to users_path
    end
  end

  def image_upload
    @user = User.find(params[:user][:id])
    @user.image = params[:user][:user_image]
    @user.save
    redirect_to @user
  end
  

  private


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def logged_out
      redirect_to(root_path) unless not signed_in?
    end
end
