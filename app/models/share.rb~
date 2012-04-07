class Share < ActiveRecord::Base

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :get_paper, :class_name => "Paper"
belongs_to :group

has_many :maillogs, :as => :about

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
   owner.get_paper
end

end
