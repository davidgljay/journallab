desc "This task is called by the Heroku cron add-on"

task :cron => :environment do

#  if Time.now.hour == 0 # run at midnight
  Membership.all.each{|m| m.save}
  Paper.first.delay.set_all_interest
  Analysis.first.delay.set_cache
#  end

end
