class Question < ActiveRecord::Base
:attr


belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :assertion
belongs_to :question

#A question owned by another question is an answer.
has_many :questions
has_many :comments
has_many :votes

has_many :filters, :foreign_key => "question_id",
                           :dependent => :destroy
has_many :groups, :through => :filters, :source => :group


#Validations
   validates :text, :presence => true

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

def owner
   if self.paper
     self.paper
   elsif self.fig
     self.fig
   elsif self.figsection
     self.figsection
   elsif self.question
     self.question.owner
   end
end

end
