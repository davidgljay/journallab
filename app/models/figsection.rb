class Figsection < ActiveRecord::Base

belongs_to :fig

has_many :assertions
has_many :comments

validates :fig_id, :presence => true

def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.last
end

def heat
   heat = comments.count
   comments.each do |c|
     heat += c.comments.count
   end
   heat
end


end
