desc "Resets information for each paper"

task :assign_anons => :environment do
	Comment.all.delay.each do |comment|
		comment.user.assign_anon_name(comment.get_paper)
	end
end

