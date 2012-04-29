class Assertion < ActiveRecord::Base
attr_accessible :text, :method_text, :about, :alt_approach

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

def owner
  if paper_id
    paper
  elsif fig_id
    fig
  elsif figsection_id
    figsection
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

def linktext
  text ? [text] : [method_text]
end

end
