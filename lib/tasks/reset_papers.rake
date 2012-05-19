desc "Resets information for each paper"

task :reset_papers => :environment do
	Paper.all.each do |paper|
		paper.authors = []
		paper.lookup_info
		paper.extract_authors
	end
end

