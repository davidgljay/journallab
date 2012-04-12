class Fig < ActiveRecord::Base

belongs_to :paper
has_many :figsections, :dependent => :destroy
has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :questions, :dependent => :destroy
has_many :shares, :dependent => :destroy
has_many :sumreqs, :dependent => :destroy
validates :paper_id, :presence => true

image_accessor :image

def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.sort!{|x,y| x.votes.count <=> y.votes.count}
     assert_list.last
end

def build_figsections(numsections)
   if numsections == 0
     nosections = true
   else
     newsections = numsections.to_i - self.figsections.count
     newsections.times do |i|
      self.figsections.create(:num => (self.figsections.count+1))
     end
   end
   @paper = get_paper  
   @paper.h_map = nil
   @paper.save
end

def heat
   heat = comments.count
   heat += questions.count
   heat += assertions.count
   comments.each do |c|
     heat += c.comments.count
   end
   questions.each do |q|
     heat += q.questions.count
   end
   figsections.each do |f|
     heat += f.heat
   end
   heat
end

def get_paper
   self.paper
end

def jquery_target
   'tr#fig' + num.to_s
end

def shortname
    "Fig " + num.to_s
end

def longname
    "Fig " + num.to_s + " of " + paper.title
end

end
