class Assertion < ActiveRecord::Base
  attr_accessible :text, :method_text, :about, :alt_approach, :get_paper_id, :owner_id, :anonymous

  belongs_to :get_paper, :class_name => "Paper"
  belongs_to :paper
  belongs_to :user
  belongs_to :fig
  belongs_to :figsection

  has_many :filters, :foreign_key => "assertion_id",
           :dependent => :destroy
  has_many :groups, :through => :filters, :source => :group


  has_many :comments
  has_many :questions
  has_many :votes

  after_initialize :default_values

  before_save :set_get_paper
  before_save :assign_anon_name

#Validations

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

  def set_get_paper
    self.get_paper_id = owner.get_paper.id
    get_paper
  end

  def linktext
    text ? [text] : [method_text]
  end

  def assign_anon_name
    self.user.assign_anon_name(self.get_paper)
  end

  private

  def default_values
    self.anonymous ||= false
  end


end
