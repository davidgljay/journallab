class Note < ActiveRecord::Base
  attr_accessible :about_id, :about_type, :text, :user_id, :folder_id

  belongs_to :about, :polymorphic => true
  belongs_to :user
  belongs_to :folder

  validates :folder,  :presence => true
  validates :user, :presence => true
  validates :about, :presence => true

end
