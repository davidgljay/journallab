class Author < ActiveRecord::Base

has_many :authorships, :foreign_key => "author_id",
                           :dependent => :destroy
has_many :papers, :through => :authorships, :source => :paper
validates_uniqueness_of :firstname, :scope => [:lastname]


end
