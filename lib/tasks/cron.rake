desc "This task is called by the Heroku cron add-on"

task :cron => :environment do

  if Time.now.hour == 0 # run at midnight
    Follow.all.each {|f| f.update_feed}
    Group.all.each {|g| g.update_feed; g.update_most_viewed}
  end

end
