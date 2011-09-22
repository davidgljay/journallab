class Figsection < ActiveRecord::Base

belongs_to :fig

has_many :assertions
has_many :comments
has_many :questions

validates :fig_id, :presence => true

def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.last
end

def letter(n)
    array = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    array[n-1]
end

def heat
   heat = comments.count
   comments.each do |c|
     heat += c.comments.count
   end
   heat
end

def get_paper
   self.fig.paper
end

end
