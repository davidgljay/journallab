desc "Sets all comments to public (may be good to destroy after use.)"

task :set_comments_to_public => :environment do	
	Group.all.each do |group|
		group.comments.each {|comment| group.make_public(comment)}
		group.questions.each {|question| group.make_public(question)}
	end
	Comment.all.each {|c| c.is_public = true; c.save}
	Question.all.each {|q| q.is_public = true; q.save}
end

