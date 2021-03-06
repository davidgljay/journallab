require 'RMagick'
include Magick

class Fig < ActiveRecord::Base

belongs_to :paper
has_many :figsections, :dependent => :destroy, :order => "figsections.num ASC"
has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :questions, :dependent => :destroy
has_many :shares, :dependent => :destroy
has_many :sumreqs, :dependent => :destroy
has_many :visits, :as => :about, :dependent => :destroy
has_many :reactions, :as => :about, :dependent => :destroy
validates :paper_id, :presence => true

image_accessor :image

def latest_assertion
     assert_list = self.assertions.sort{|x,y| x.created_at <=> y.created_at}
     assert_list.sort!{|x,y| x.votes.count <=> y.votes.count}
     assert_list.last
end

def meta_comments
	meta_comments = []
	meta_comments << self.comments
	figsections.each do |s|
		meta_comments << s.comments
	end
	meta_comments.flatten!
        meta_comments.sort!{|x,y| x.created_at <=> y.created_at}
	meta_comments.sort!{|x,y| y.votes.count <=> x.votes.count}
end

#Returns the comment with the most nods
# Ties are broken by recency
def hottest_comment
  unless comments.empty?
    comments.map{|c| [c,c.votes.count]}.sort{|x,y| y[1] <=> x[1]}.first[0]
  end
end

def build_figsections(numsections)
   	if numsections == 0
     		self.nosections = true
        self.save
   	else
     		newsections = numsections.to_i - self.figsections.count
		if newsections > 0
     			newsections.times do |i|
      				self.figsections.create(:num => (self.figsections.count+1))
			end
			self.paper.reset_heatmap
		end
		numsections
	end
end

def heat
   heat = comments.count
   heat += questions.count
   heat += assertions.count
   heat += reactions.count
   comments.each do |c|
     heat += c.comments.count
   end
   questions.each do |q|
     heat += q.questions.count
     heat += q.comments.count
   end
   figsections.each do |s|
	heat += s.heat
   end
   heat
end

def get_paper
   	self.paper
end

def jquery_target
   	'div#fig' + id.to_s
end

def shortname
    	"Fig " + num.to_s
end

def longname
    	"Fig " + num.to_s + " of " + paper.title
end

def inspect
	"fig" + id.to_s
end

end
