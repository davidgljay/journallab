desc "Sets get_paper for every item that has it."

task :set_get_paper => :environment do
	everybody = Comment.all + Question.all + Vote.all + Assertion.all + Share.all + Sumreq.all
	everybody.each {|e| e.set_get_paper}
end

