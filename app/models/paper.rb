class Paper < ActiveRecord::Base

has_many :authorships, :foreign_key => "paper_id",
                           :dependent => :destroy
has_many :authors, :through => :authorships, :source => :author

#Validations
   validates :pubmed_id, :presence => true,
                         :length => { :is => 8 },
                         :uniqueness => true
end
