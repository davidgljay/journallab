class Assertion < ActiveRecord::Base
attr_accessible :text

belongs_to :paper
belongs_to :user
belongs_to :fig
belongs_to :figsection

has_many :filters, :foreign_key => "assertion_id",
                           :dependent => :destroy
has_many :groups, :through => :filters, :source => :group


has_many :comments
has_many :questions
has_many :votes

#Validations
   validates :text, :presence => true,
                    :length => { :maximum => 300 }
   validates :user_id, :presence => true 

def owner_id
  if paper_id
    paper_id
  elsif fig_id
    fig_id
  elsif figsection_id
    figsection_id
  end
end

def get_paper
  if paper_id
    paper
  elsif fig_id
    fig.paper
  elsif figsection_id
    figsection.fig.paper
  end
end

#Set up filtering mechanisms 
#def include_in_filter?
#  if self.group
#  viewer = current_user
   # For classes (like, in a classroom, not like in programming.)
#    if self.group.category == 'class'
#      if viewer.lead_of?(self.group)
#        return true
#      elsif self.find_paper.group
#      end
#    end
#  else
  # If it's not part of a group it's public, so make it visible.
#    return true
#  end
#end

end
