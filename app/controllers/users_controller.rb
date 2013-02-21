class UsersController < ApplicationController
before_filter :authenticate_user!, :except => [:new, :create, :show]
before_filter :correct_user, :only => [:edit, :update, :unsubscribe, :email_subscriptions, :image_upload]
before_filter :admin_user,   :only => [:destroy, :index]


  def index
    @title = "All users"
    @users = Kaminari.paginate_array(User.all.sort{|x,y| y.created_at <=> x.created_at}).page(params[:page]).per(20)
    respond_to do |format|
      format.html
      format.csv { send_data User.new.to_csv }
    end
  end

  def show
   @user = User.find(params[:id])
   @title = @user.name

  end

# This functionality has been replaced by Devise.
#  def new
#   @title = "Get Started"
#   @user = User.new
#   @groups = Group.all
#  end

#  def reset_password
#   @title = "Reset User Password"
#   if params[:email] != nil
#     @user = User.find_by_email(params[:email])
#     if @password = current_user.reset_user_password(@user)
#      flash[:success] = @user.name + "'s password has been reset to " + @password
#     else
#       flash[:error] = "You must be an admin, how did you get here?"
#     end
#   end
#   render 'reset_password'
#  end

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
      u.verified = true
      u.confirmed_at = Time.now
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

#  This functionality has been replaced by Devise.
#  def create
#   @user = User.new(params[:user])
#   @user.generate_anon_name
#   msg = ""
#   @user.email.downcase!
#   	if @user.save
#      		sign_in @user
#      		url = root_path
#		email = true
#      		unless params[:group_id].nil? 
#        		@group = Group.find(params[:group_id])
#        		@user.groups << Group.find(params[:group_id])
#        		msg = " You've been added to " + @group.name
#        		url = @group
#      		end
#      		flash[:success] = "Welcome to Journal Lab!" + msg
#		if @user.email.last(9) != "@ucsf.edu"
#			flash[:error] = "For the time being, Journal Lab only accepts e-mail addresses ending in '@ucsf.edu'."
#			flash[:success] = nil
#			url = new_user_path
#			sign_out
#			@user.destroy
#			email = false
#			render "new"
#		else
#  			redirect_to root_path
#		end
#  	else
#     		@title = "Sign up"
#		render "new"
#	end
#	@user.deliver_user_verification_instructions! if email
#  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
    end
      redirect_to @user
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
       flash[:error]="You may not destroy another administrator."
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

  #def unsubscribe
  #  	@user = User.find(params[:id])
	#    @user.subscriptions.each(:category => "all", :receive_mail => false)
	#    flash[:success] = "You have been unsubscribed from Journal Lab e-mail."
	#redirect_to root_path
  #end

# Old code for managing sharing within labs. Bring back if I re-enable this functionality.
# def share_digest
#   	@user = User.find(params[:id])
#	@user.subscriptions.create!(:category => "share_notification", :receive_mail => false)
#	@user.subscriptions.create!(:category => "share_digest", :receive_mail => true)
#	flash[:success] = "You will now recieve Journal Lab papers as a daily digest."
#	redirect_to root_path
#  end
	
  def history
    #runs /users/history.js.erb to make the history feed appear on from the top menu.
   @recent_visits = current_user.visited_papers.reverse.uniq.first(20)
  end

  def subscriptions
    # Interface for managing email subscriptions
    # Putting language in the controller, I should move it to a YML file when I'm not on an airplane.
    # Note- when adding or removing a class of email please also check the mailer.rb file and the defaults method in subscription.rb.
    @title = 'Email Settings'
    @user = current_user
    @subscription_map = @user.subscription_map
    @options = []
    @options << {:type => 'recurring', :short => 'weekly', :option => 'Weekly Update of New Papers', :desc => ''}
    @options << {:type => 'recurring', :short => 'alerts', :option => 'Monthly (or less) Open Science Alert', :desc => 'Stay up to date on the ways that scientists are transforming academic publishing.'}
    @options << {:type => 'notification', :short => 'reply', :option => 'Someone responds to one of my comments', :desc => ''}
    @options << {:type => 'notification', :short => 'jclub', :option => 'One of my virtual journal clubs discusses a new paper', :desc => ''}
    @options << {:type => 'notification', :short => 'impact', :option => 'One of my contributions makes a significant impact', :desc => ''}
    @options << {:type => 'notification', :short => 'author', :option => 'There is discussion about one of my papers', :desc => 'We will email you when a paper that you have written is discussed for the first time, or when discussion on that paper hits significant milestones.'}
    @options << {:type => 'notification', :short => 'milestone', :option => 'My reputation on Journal Lab hits a major milestone', :desc => 'We will email you periodically as your reputation develops in the Journal Lab community, for example when your contributions on the system have been viewed 1000 times.'}

  end

  def set_subscriptions
    @settings = params[:user]
    @user = current_user
    @settings.to_a.each do |sub|
      option = @user.subscriptions.select{|s| s.category == sub[0]}.first
      option.receive_mail = (sub[1].to_i == 1)
      option.save
    end
    flash[:success] = 'Your email settings have been updated!'
    redirect_to @user
  end



  private


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user == @user
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def logged_out
      redirect_to(root_path) unless not signed_in?
    end
end
