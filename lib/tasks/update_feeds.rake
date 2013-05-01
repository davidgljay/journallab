desc "This task updates feeds"

task :update_feeds => :environment do
    Follow.update_all_feeds
end
