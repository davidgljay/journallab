class Note < ActiveRecord::Base
  attr_accessible  :text, :about, :about_type, :about_id, :user_id, :folder_id, :user, :folder

  belongs_to :about, :polymorphic => true
  belongs_to :user
  belongs_to :folder

  validates :folder,  :presence => true
  validates :user, :presence => true
  validates :about, :presence => true

end
