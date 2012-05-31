desc "This task updates feeds"

task :update_feeds => :environment do
    Group.all.each do |g| 
	g.update_feed
	g.update_most_viewed
    end
end
