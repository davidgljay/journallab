class Mailer < ActionMailer::Base
  default :from => "david@journallab.com"


  #Mailer used for testing purposes
  def test_email(user)
    @user = user
    mail(:to => to(user.email), :subject => "This is a test.")
  end

  #Someone has responded to your comment
  def comment_response(response)
      if response.class == Comment && !response.comment.nil?
        @recipient = response.comment.user
        o = response.comment.owner
        @type = "comment"
      elsif !response.question.nil?
        @recipient = response.question.user
        o = response.question.owner
        @type = "question"
      end
      @commenter = response.user
      @reply = response.text
      @paper = response.get_paper
      @owner = o.class == Paper ? "" : " " + o.shortname + " of " 
      @intro = rand_intro
      unless @recipient == @commenter && Rails.env != 'development'
         @maillog = Maillog.create!(:purpose => 'comment_response', :user => @recipient, :about => response)
         @url = paper_path(@paper, :only_path => false )
         @m_url = paper_path(@paper, :only_path => false ) + '/m/' + @maillog.id.to_s
         mail(:to => to(@recipient.email), :subject => "Nerd Alert! Response to your J.Lab " + @type + " on" + @owner + @paper.title)
      end
  end

  def share_notification(share)
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
      share.group.users.each do |u|
        @recipient = u
        @maillog = Maillog.create!(:purpose => 'share_notification', :user => @recipient, :about => share)
        @url = paper_path(@paper, :only_path => false )
        @m_url = paper_path(@paper, :only_path => false ) + '/m/' + @maillog.id.to_s
        mail(:to => to(@recipient.email), :subject => @user.name + " has shared something on J.lab: " + @short_sharetext)
      end
  end 

  def rand_intro
    intros = ["Aren't you cool!", "Nice work!", "Hey there,", "Good news!", "You're making waves,"]
    intros[rand(intros.length)]
  end

  def to(email)
    Rails.env == 'development' ? 'test.jlab@gmail.com' : email
  end
end
