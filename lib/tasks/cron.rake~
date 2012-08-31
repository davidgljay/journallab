desc "This task is called by the Heroku cron add-on"

task :cron => :environment do

#  if Time.now.hour == 0 # run at midnight
    Follow.all.each {|f| f.delay.update_feed}
    newshare_groups = Group.all.select{|g| g.newshares?}
    User.all.select{|u| !(u.groups && newshare_groups).empty? && s.receive_mail}.each{|u| Mailer.delay.share_digest(u).deliver if u.receive_mail?}

#  end

end
