desc "Resets heatmaps for each paper"

task :reset_heatmaps => :environment do
	Paper.all.each do |paper|
		paper.h_map = nil
		paper.heatmap
	end
end

