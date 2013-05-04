class Commentnotice < ActiveRecord::Base
  attr_accessible :comment_date, :comment_id, :follow_id, :paper_id

  belongs_to :follow
  belongs_to :comment
  belongs_to :paper

  before_validation :settings

  validates_presence_of :follow
  validates_presence_of :comment
  validates_presence_of :paper

  def settings
    self.paper = comment.get_paper
    self.comment_date = comment.created_at
  end
end
