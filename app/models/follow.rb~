class Follow < ActiveRecord::Base

belongs_to :user
belongs_to :follow, :polymorphic => true

validates :name, :presence => true

def classname
	"follow_" + id.to_s
end

def inspect
	name
end

end
