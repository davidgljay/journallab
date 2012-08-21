desc "Manual call of the cron run by heroku at midnight"

task :manual_cron => :environment do

    Follow.all.each {|f| f.delay.update_feed}
    newshare_groups = Group.all.select{|g| g.newshares?}
    User.all.select{|u| !(u.groups && newshare_groups).empty? && s.receive_mail}.each{|u| Mailer.delay.share_digest(u).deliver if u.receive_mail?}

end
