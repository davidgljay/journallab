class Mailer < ActionMailer::Base
  default :from => "'Journal Lab' <david@journallab.com>"


  #Mailer used for testing purposes
  def test_email(user)
    @user = user
    mail(:to => to(user.email), :subject => "This is a test.")
  end

  #Someone has responded to your comment
  def comment_response(response,user) 
      @recipient = user
      if response.class == Comment && !response.comment.nil?
        @thread = response.comment
        o = @thread.owner
        @type = "comment"
      elsif !response.question.nil?
        @thread = response.question
        o = @thread.owner
        @type = "question"
      end     
      @commenter = response.user
      @anon = response.anonymous
      @reply = response.text
      @paper = response.get_paper
      @owner = o.class == Paper ? " " : " " + o.shortname + " of " 
      @intro = rand_intro
      @maillog = Maillog.create!(:purpose => 'comment_response', :user => @recipient, :about => response)
      @url = paper_path(@paper, :only_path => false )
      @m_url = paper_path(@paper, :only_path => false ) + '/m/' + @maillog.id.to_s
      mail(:to => to(@recipient), :subject => "Response to your J.Lab " + @type + " on" + @owner + @paper.title)
  end

  #Notify the appropriate group when something is shared
  def share_notification(share, user)
      @recipient = user
      @share = share
      @user = @share.user
      @item = @share.owner
      @paper = @item.get_paper
      @item_name = @item.longname
      @item_summary = @item.latest_assertion
      @short_sharetext = @share.text.split.first(6) * ' '
      if @share.text.length > @short_sharetext.length
         @short_sharetext << '...' 
      end
      @maillog = Maillog.create!(:purpose => 'share_notification', :user => @recipient, :about => share)
      @url = paper_path(@paper, :only_path => false )
      @m_url = paper_path(@paper, :only_path => false ) + '/m/' + @maillog.id.to_s
      mail(:to => to(@recipient), :subject => @user.name + " has shared something on J.lab: " + @short_sharetext)
  end 

  def share_digest(user)
	@recipient = user
	shares = user.groups.map{|g| g.shares}.flatten.select{|share| share.created_at > Time.now - 1.day}.uniq
	@shares = []
	@users = []
	shares.each do |s|
	      share = {}
	      share[:user] = s.user
	      share[:item] = s.owner
	      share[:text] = s.text
	      share[:paper] = s.get_paper
	      share[:item_name] = share[:item].longname
	      share[:item_summary] = share[:item].latest_assertion
	      share[:url] = paper_path(share[:paper], :only_path => false )
	      @shares << share
	      @users << share[:user].firstname
	end
      if shares.count == 1
        @short_sharetext = shares.first.text.split.first(6) * ' '
        if shares.first.text.length > @short_sharetext.length
           @short_sharetext << '...' 
        end
	@subject = @users.first + " has shared something on Journal Lab: " + @short_sharetext
      else
	@subject = "New papers shared by " + @users.first(5) * ', '
      end
      @maillog = Maillog.create!(:purpose => 'share_digest', :user => @recipient, :about => shares.first)
      @shares.each{|share|  share[:m_url] = paper_path(share[:paper], :only_path => false ) + '/m/' + @maillog.id.to_s}
      mail(:to => to(@recipient), :subject => @subject )
  end

  #Notify the head of a group when a new member is added
  def group_add_notification(group,recipient, newuser)
	@group = group
	@recipient = recipient
	@newuser = newuser
	@url = group_path(@group, :only_path => false) + '/remove/' + @newuser.id.to_s 
	@maillog = Maillog.create!(:purpose => 'group_add_notification', :user => @recipient, :about => @group)
      	mail(:to => to(@recipient), :subject => @newuser.name + " has joined the group " + @group.name )
  end

  def user_verification(user)
	@recipient = user
	@url = user_path(@user, :only_path => false ) + '/verify/#{user.perishable_token}'
	mail(:to => to(@recipient), :subject => "Please verify your account on Journal Lab.")
  end

  def rand_intro
    intros = ["Aren't you cool!", "Nice work!", "Hey there,", "Good news!", "You're making waves,"]
    intros[rand(intros.length)]
  end

  def to(user)
    Rails.env == 'development' ? 'test.jlab@gmail.com' : user.email
  end

end
