desc "This task updates feeds"

task :update_feeds => :environment do
    Group.all.each do |g| 
	g.delay.update_feed
	g.delay.update_most_viewed
    end
end
