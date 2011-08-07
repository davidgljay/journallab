class Fig < ActiveRecord::Base

belongs_to :paper
has_many :figsections
has_many :assertions
has_many :comments
has_many :questions

validates :paper_id, :presence => true

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


end
