desc "This task updates feeds"

task :update_feeds => :environment do
    Follow.update_all_feeds
    Paper.delay.set_all_interest(false)
end
