desc "This task updates feeds"

task :update_feeds => :environment do
    Follow.all.each do |f| 
	f.delay.update_feed
    end
end
