desc "Sets interest level for every paper in the system."

task :set_paper_interest => :environment do
	Paper.first.delay.set_all_interest
end
