class Journal < ActiveRecord::Base

has_many :follows, :as => :follow

validates :name, :presence => true, :uniqueness => true
validates :feedurl, :presence => true, :uniqueness => true



end
