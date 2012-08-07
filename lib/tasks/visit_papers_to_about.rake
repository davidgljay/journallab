desc "Transfers visit.paper to visit.about "

task :visit_papers_to_about => :environment do
	Visit.all.each do |visit|
		visit.about = visit.paper
		visit.count ||=0
		if visit.count > 1
			(visit.count - 1).times do
				Visit.new(:about => visit.about, :user => visit.user).save
			end
		end
		visit.count = nil
		visit.visit_type ||= 'paper'		
		visit.save
	end
end

