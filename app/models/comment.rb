class Comment < ActiveRecord::Base

attr_accessible :text

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :assertion
belongs_to :comment
belongs_to :question

has_many :comments
has_many :votes

#Validations
   validates :text, :presence => true

   #validates_associated :user

   validates_inclusion_of :form, :in => %w( comment reply qcomment )
# Create a way to link to other papers using a [pubmed id]
# If this works it should be fairly straightforward to implement direct links to figures, etc.

def linktext
   comment = text.split(/[\[\]]/)
   linktext = []
   comment.each do |phrase|
      if phrase.to_i.to_s == phrase 
        if p = Paper.find_by_pubmed_id(phrase)
        elsif p = Paper.create( :pubmed_id => phrase.to_i )
            p.lookup_info
        end
        linktext << p
      elsif phrase.split(':')[0].to_i.to_s == phrase.split(':')[0]
        phr = phrase.split(':')
        if phr.length == 2
           f = Paper.find_by_pubmed_id(phr[0]).figs[(phr[1].to_i - 1)]
        elsif phr.length == 3
           f = Paper.find_by_pubmed_id(phr[0]).figs[(phr[1].to_i - 1)].figsections[(phr[2].to_i - 1)]
        end
        linktext << f
      else
        linktext << phrase
      end
   end
   linktext
end        

def get_paper
   if self.paper
     self.paper
   elsif self.fig
     self.fig.paper
   elsif self.figsection
     self.figsection.fig.paper
   end
end
   
 
end
