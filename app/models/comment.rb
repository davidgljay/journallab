class Comment < ActiveRecord::Base

attr_accessible :text, :form, :paper_id, :fig_id, :figsection_id, :user_id, :assertion_id, :get_paper_id, :anonymous

belongs_to :user
belongs_to :paper
belongs_to :get_paper, :class_name => "Paper"
belongs_to :fig
belongs_to :figsection
belongs_to :assertion
belongs_to :comment
belongs_to :question

has_many :comments, :order => "created_at ASC"
has_many :votes
has_many :maillogs, :as => :about

before_save :set_get_paper

has_many :filters, :foreign_key => "comment_id",
                           :dependent => :destroy
has_many :groups, :through => :filters, :source => :group

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
            p.extract_authors
        end
        linktext << p
      elsif (phrase.split(/[;:,.]/)[0].to_i.to_s == phrase.split(/[;:,.]/)[0])  
        phr = phrase.split(/[;:,.]/)
        if p = Paper.find_by_pubmed_id(phr[0])
        elsif p = Paper.create( :pubmed_id => phr[0].to_i )
            p.lookup_info
            p.extract_authors
        end
        if phr.length == 2
           p.build_figs(phr[1].to_i)
           f = p.figs[(phr[1].to_i - 1)]
        elsif phr.length == 3
           p.build_figs(phr[1].to_i)
           if phr[2].length == 1 && (phr[2] =~ /[a-zA-Z]/) == 0
              phr[2] = Figsection.new.number(phr[2])
           end
           p.figs[(phr[1].to_i - 1)].build_figsections(phr[2].to_i)
           f = p.figs[(phr[1].to_i - 1)].figsections[(phr[2].to_i - 1)]
        end
        linktext << f
      else
        linktext << phrase
      end
   end
   linktext
end        

def set_get_paper
	self.get_paper_id = owner.get_paper.id
	get_paper
end

def owner
   if self.paper
     self.paper
   elsif self.fig
     self.fig
   elsif self.figsection
     self.figsection
   elsif self.comment
     self.comment.owner
   elsif self.question
     self.question.owner
   end
end
 
end
