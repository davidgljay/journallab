class Mailer < ActionMailer::Base
  default :from => "'J.Lab Nerd Alert' <david@journallab.com>"


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

  def rand_intro
    intros = ["Aren't you cool!", "Nice work!", "Hey there,", "Good news!", "You're making waves,"]
    intros[rand(intros.length)]
  end

  def to(user)
    Rails.env == 'development' ? 'test.jlab@gmail.com' : user.email
  end

end
