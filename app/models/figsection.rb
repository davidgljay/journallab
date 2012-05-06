class Figsection < ActiveRecord::Base

belongs_to :fig

has_many :assertions, :dependent => :destroy
has_many :comments, :dependent => :destroy
has_many :questions, :dependent => :destroy
has_many :shares, :dependent => :destroy
has_many :sumreqs, :dependent => :destroy

validates :fig_id, :presence => true

def latest_assertion
     assert_list = self.assertions.sort {|x,y| x.created_at <=> y.created_at}
     assert_list.sort!{|x,y| x.votes.count <=> y.votes.count}
     assert_list.last
end

def letter(n = self.num)
    letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    letters[n-1]
end

def number(n)
    letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    letters.index(n.upcase)+1
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
     heat += q.comments.count
   end
   heat
end

def get_paper
   	self.fig.paper
end

def jquery_target
   	"div#figsection" + id.to_s
end

def shortname
    	"Fig " + fig.num.to_s + letter
end

def longname
    	"Fig " + num.to_s + letter + " of " + fig.paper.title
end

def inspect
	'figsection' + id.to_s
end

end
