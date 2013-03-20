class Analysis < ActiveRecord::Base
  attr_accessible :cache

  serialize :cache

  before_save :check_cache

  def set_cache
    cache = {}
    cache[:vanity] = [["Comments",graph_by_day(Comment.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))], ["Reactions",graph_by_day(Reaction.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))], ["Summaries",graph_by_day(Assertion.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))],["Users", graph_by_day(User.where('created_at > ? ', Time.now - 1.month))],["Custom Feeds", graph_by_day(Follow.where('created_at > ? AND user_id <> 1 AND user_id <> 2 AND user_id <> 85', Time.now - 1.month))]]
    cache[:views] = [["Papers", graph_by_day(Visit.where("created_at > ? AND visit_type = 'paper' AND user_id <> 1 AND user_id <> 2 AND user_id <> 85", Time.now - 1.month))], ["Comments", graph_by_day(Visit.where("created_at > ? AND visit_type = 'comment' AND user_id <> 1 AND user_id <> 2 AND user_id <> 85", Time.now - 1.month))], ["Feeds", graph_by_day(Visit.where("created_at > ? AND visit_type = 'feed' AND user_id <> 1 AND user_id <> 2 AND user_id <> 85", Time.now - 1.month))]]
    cache[:nods_per_discussion] = histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.votes.count})
    cache[:replies_per_discussion] =  histogram(Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count} + Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|q| q.comments.count + q.questions.count})
    cache[:nod_discussion_ratio] = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.votes.count}.inject{|sum, n| sum + n}, Question.where('created_at > ?', Time.now - 1.month).map{|c| c.votes.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ?', Time.now - 1.month).count])
    cache[:reply_discussion_ratio] = make_ratio([Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').map{|c| c.comments.count}.inject{|sum, n| sum + n}, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).map{|c| c.comments.count + c.questions.count}.inject{|sum, n| sum + n}],[Comment.where('created_at > ? AND form = ?', Time.now - 1.month, 'comment').count, Question.where('created_at > ? AND question_id IS NULL', Time.now - 1.month).count])
    cache[:action_pageview__ratio] = make_ratio([Comment.where('created_at > ?', Time.now - 1.month).count, Question.where('created_at > ?', Time.now - 1.month).count, Vote.where('created_at > ?', Time.now - 1.month).count],[Visit.where('created_at > ?', Time.now - 1.month).count])
    cache[:user_count] = User.count
    cache[:total_users] = [["Users",graph_total_by_day(User.all)]]
    cache[:active_users] = Visit.all.select{|v| v.user_id}.select{|v| v.created_at > Time.now - 1.month}.map{|v| v.user_id}.uniq
    cache[:returning_this_month] = cache[:active_users].map{|u| User.find(u)}.select{|user| user.created_at > Time.now - 1.month && user.visits.last.created_at.to_date != user.created_at.to_date}.count
    cache[:registered_this_month] = User.all.select{|u| u.created_at > Time.now - 1. month}.count
    cache[:visits_per_user] = histogram(User.all.map{|u| u.visits.count})
    cache[:discussion_per_user] = histogram(User.all.map{|u| u.reactions.count + u.comments.count})
    self.cache = cache
    self.save
  end

  def check_cache
    if cache.nil?
      set_cache
    end
  end


  #
  # Analytics functions for the dashboard (and eventually for other places.)
  #

  # Creates an array of days from "start" to "finish"
  def dayrange(start, finish)
    if start > finish
      s = start
      start = finish
      finish = s
    end
    days = [start]
    day = start + 1.day
    while day <= finish
      days << day
      day += 1.day
    end
    days
  end

  # Creates a graph of ratios
  # Turns [[[day1,x1], [day2,x2]],[[day1,y1]]] into [[day1, x1/y1],[day2,0]]

  def make_ratio_graph(array1, array2)
    if array1.empty? || array2.empty?
      ratio = [[Time.now],[0]]
    else
      days = dayrange([array1[0][0] + 1.day, array2[0][0] + 1.day].min,[array1[0][-1], array2[0][-1]].max)
      ratio = [days,[]]
      days.each do |day|
        # This may need to change due to change in array structure
        x = array1[0].map{|a| a.midnight}.include?(day) ? array1[1][array1[0].index(day)] : 0
        y = array2[0].map{|a| a.midnight}.include?(day) ? array2[1][array2[0].index(day)] : 0
        float = y == 0 ? 0 : (x.to_f/y.to_f)
        ratio[1] << [float]
      end
    end
    ratio
  end

  #Accepts two arrays of integers and spits back a float ratio

  def make_ratio(array1, array2)
    if array1.empty? || array2.empty?
      result = 0
    else
      result = array1.compact.inject(0){|sum, item| sum + item}.to_f/array2.compact.inject(0){|sum, item| sum + item}.to_f
    end
    result
  end

  #Takes a 2D array
  def export_data(array, name = "data")
    CSV.open("public/data/" + name + "_" + Time.now.strftime("%m_%d_%Y_%H:%M:%S") + ".csv", "w") do |csv|
      csv << array
    end
  end

  #Takes an array, returns a frequency array by day
  def graph_by_day(array)
    if array.empty?
      graph = [[Time.now, 0]]
    else
      array.sort!{|x,y| x.created_at <=> y.created_at}
      finish = array.last.created_at + 1.day
      start = array.first.created_at - 1.day
      days = []
      day = start.midnight
      while day < finish.midnight
        days << day
        day += 1.day
      end
      graph = days.map{|day| [day, array.select{|object| object.created_at > day && object.created_at < day + 1.day}.count]}
    end
  end

  def graph_total_by_day(array)
    total = graph_by_day(array)
    yesterday = 0
    total.each do |t|
      t[1] += yesterday
      yesterday = t[1]
    end
    total
  end

  #Histogram
  def histogram(array)
    histo = array.uniq.map{|unit| [unit, array.count{|x| x == unit}]}.sort{|x,y| x[0]<=>y[0]}
  end
end
