class Maillog < ActiveRecord::Base

belongs_to :user
belongs_to :about, :polymorphic => true

def paper_view_conversion_check(paper)
    if paper == about.get_paper
      self.conversiona = Time.now #if conversiona.nil?
      self.save
    end
end

def conversion_b_flag
  conversionb = Time.now if conversionb.nil?
  save
end

def mail_types
  Maillog.all.map{|m| m.category}.uniq
end

end
