desc "Resets information for each paper"

task :reset_papers => :environment do
	Paper.all.each do |paper|
		paper.delay.lookup_info
	end
end

