class PagesController < ApplicationController
  def home
    @title = "Home"
    if signed_in? && !current_user.groups.empty?
      @group = current_user.groups.last
    else
      @group = Group.new
    end
    @feed = []
    if @group.category == "lab"
      @group.feed.each do |item|
 
        unless item.class == Visit
          if item.text.length > 100
            elips = '...'
          else
            elips = ''
          end
        end 
 
        if item.class == Visit
          @feed << [item.user, 'visited the paper', item.paper]
        elsif item.class == Assertion
          if item.owner.class == Paper
             ofthe = ''
          elsif item.owner.class == Fig
             ofthe = 'Fig ' + item.owner.num.to_s + ' of '
          elsif item.owner.class == Figsection
             ofthe = 'Fig ' + item.owner.fig.num.to_s + ', Section ' + item.owner.letter(item.owner.num) + ' of '
          end
          @feed << [item.user, 'summarized ' + ofthe + 'the paper', item.get_paper, item.text.first(100) + elips]
        elsif item.class == Comment || item.class == Question
          if item.owner.class == Paper
             ofthe = ''
          elsif item.owner.class == Fig
             ofthe = 'Fig ' + item.owner.num.to_s + ' of '
          elsif item.owner.class == Figsection
             ofthe = 'Fig ' + item.owner.fig.num.to_s + ', Section ' + item.owner.letter(item.owner.num) + ' of '
          end
          @feed << [item.user, 'discussed ' + ofthe + 'the paper', item.get_paper, item.text.first(100) + elips]
        end
      end
    end
    # If it's a class
    if @group.category == "class"
       @classdates = []
       @general = []
       @group.filters.all.each do |f|
         if f.paper_id != nil && f.date != nil
           @classdates << [f.paper_id, f.date, f.supplementary]
         elsif f.date.nil? && f.paper_id != nil
           @general << f.paper
         end
       end
       @classdates.sort!{|x,y| x[1] + x[2].object_id.minutes <=> y[1] + y[2].object_id.minutes}
     end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

end
