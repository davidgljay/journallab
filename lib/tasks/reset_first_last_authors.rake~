desc "Sets first and last author for each paper"

task :set_first_last_authors => :environment do
	Paper.all.each do |paper|
		paper.assign_first_and_last_authors
	end
end

