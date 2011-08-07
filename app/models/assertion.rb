class Assertion < ActiveRecord::Base
attr_accessible :text

belongs_to :paper
belongs_to :user
belongs_to :fig
belongs_to :figsection

has_many :comments
has_many :questions

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

def find_paper
  if paper_id
    paper
  elsif fig_id
    fig.paper
  elsif figsection_id
    figsection.fig.paper
  end
end


end
