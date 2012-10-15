desc "Sets interest level for every paper in the system."

task :set_paper_interest => :environment do
	Paper.all.delay.each {|p| p.set_interest}
end
