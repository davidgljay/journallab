desc "This task updates feeds"

task :update_feeds => :environment do
    Folow.last.update_all_feeds
end
