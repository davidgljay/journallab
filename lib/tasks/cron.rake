desc "This task is called by the Heroku cron add-on"

task :cron => :environment do

#  if Time.now.hour == 0 # run at midnight
  Membership.all.each{|m| m.save}
  if Time.now.monday? || Time.now.thursday?
     Paper.first.delay.set_all_interest
   end
#  end

end
