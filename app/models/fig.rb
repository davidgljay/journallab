class Fig < ActiveRecord::Base

belongs_to :paper
has_many :figsections, :dependent => :destroy
has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :questions, :dependent => :destroy

validates :paper_id, :presence => true

image_accessor :image

def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.last
end

def build_figsections(numsections)
   numsections.to_i.times do |i|
     self.figsections.create(:num => (self.figsections.count+1))
   end
end

def heat
   heat = comments.count
   comments.each do |c|
     heat += c.comments.count
   end
   heat
end

def get_paper
   self.paper
end

end
