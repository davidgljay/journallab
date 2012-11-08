desc "Manual call of the cron run by heroku at midnight"

task :manual_cron => :environment do
    newshare_groups = Group.all.select{|g| g.newshares?}
    User.all.select{|u| !(u.groups && newshare_groups).empty? && s.receive_mail}.each{|u| Mailer.delay.share_digest(u).deliver if u.receive_mail?}
    if Time.now.monday?
      Paper.first.delay.set_all_interest
    end
end
