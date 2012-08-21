desc "Resets reaction maps for each paper"

task :reset_reaction_maps => :environment do
	Paper.all.delay.each do |paper|
		paper.h_map = nil
		paper.heatmap
	end
end

