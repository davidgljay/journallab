desc "This task is called by the Heroku cron add-on"

task :cron => :environment do

  if Time.now.hour == 0 # run at midnight
    Follow.all.each {|f| f.delay.update_feed}
    Subscription.all.select{|s| s.category == "share_digest" && s.receive_mail}.map {|s| s.user}.each{|u| Mailer.delay.share_digest(u).deliver if u.receive_mail?}
  end

end
