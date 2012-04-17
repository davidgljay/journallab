class Share < ActiveRecord::Base

belongs_to :user
belongs_to :paper
belongs_to :fig
belongs_to :figsection
belongs_to :get_paper, :class_name => "Paper"
belongs_to :group

has_many :maillogs, :as => :about

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

def get_paper
   owner.get_paper
end

def linktext
   comment = text.split(/[\[\]]/)
   linktext = []
   comment.each do |phrase|
      if phrase.to_i.to_s == phrase 
        if p = Paper.find_by_pubmed_id(phrase)
        elsif p = Paper.create( :pubmed_id => phrase.to_i )
            p.lookup_info
            p.extract_authors
        end
        linktext << p
      elsif (phrase.split(/[;:,.]/)[0].to_i.to_s == phrase.split(/[;:,.]/)[0])  
        phr = phrase.split(/[;:,.]/)
        if p = Paper.find_by_pubmed_id(phr[0])
        elsif p = Paper.create( :pubmed_id => phr[0].to_i )
            p.lookup_info
            p.extract_authors
        end
        if phr.length == 2
           p.build_figs(phr[1].to_i)
           f = p.figs[(phr[1].to_i - 1)]
        elsif phr.length == 3
           p.build_figs(phr[1].to_i)
           if phr[2].length == 1 && (phr[2] =~ /[a-zA-Z]/) == 0
              phr[2] = Figsection.new.number(phr[2])
           end
           p.figs[(phr[1].to_i - 1)].build_figsections(phr[2].to_i)
           f = p.figs[(phr[1].to_i - 1)].figsections[(phr[2].to_i - 1)]
        end
        linktext << f
      else
        linktext << phrase
      end
   end
   linktext
end        


end
