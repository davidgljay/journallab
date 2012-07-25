class Reaction < ActiveRecord::Base

belongs_to :user
belongs_to :comment
belongs_to :about, :polymorphic => true
belongs_to :get_paper, :class_name => "Paper"


validates :user_id, :presence => true, :uniqueness => {:scope => [:name, :about_id, :about_type] } 
validates :name, :presence => true

before_save :set_get_paper

def set_get_paper
	self.get_paper = about.get_paper
	get_paper
end


end
