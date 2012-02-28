class Group < ActiveRecord::Base

# Used to denote labs, classes, etc. Primarily involved in filtering mechanisms (ie, comments visible to a particular group.
# Elements:
# Name: text - Name of group
# Desc: text - Group description
# Category: string - Type of group (class, lab, etc), affects filtering system used.
# Connected to User class through memerships model


has_many :memberships, :foreign_key => "group_id",
                           :dependent => :destroy
has_many :users, :through => :memberships, :source => :user

#Filter Associations
has_many :filters, :foreign_key => "group_id",
                           :dependent => :destroy
has_many :papers, :through => :filters, :source => :paper
has_many :comments, :through => :filters, :source => :comment
has_many :questions, :through => :filters, :source => :question
has_many :assertions, :through => :filters, :source => :assertion
has_many :sumreqs, :dependent => :destroy
has_many :shares, :dependent => :destroy


validates :category, :presence => true
validates :name, :presence => true

#Functions for adding and removing users

def add(user)
   unless users.include?(user)
     self.users << user
   m = self.memberships.find_by_user_id(user.id)
   m.lead = false
   m.save     
   end
end

def make_lead(user)
   unless users.include?(user)
      self.users << user
   end
   m = self.memberships.find_by_user_id(user.id)
   m.lead = true
   m.save
end

def remove(user)
    if self.users.include?(user)
      self.memberships.find_by_user_id(user.id).destroy
    end
end

# Public = 1
# Group = 2
# Private = 3
# Functions for setting up filters
def make_public(item, date = nil, supplementary = false)
  unless make_filter(item, 1, date, supplementary)
    f = find_filter_by_item(item)
    f.state = 1
    f.save
  end
  if item.class != Paper
      item.is_public = true
      item.save
  end
end    
  
def make_group(item, date = nil, supplementary = false)
  unless make_filter(item, 2, date, supplementary)
    f = find_filter_by_item(item)
    f.state = 2
    f.save
  end
  unless otherwise_public?(item) 
      if item.class != Paper
        item.is_public = false
        item.save
      end
  end
end

def make_private(item, date = nil, supplementary = false)
  unless make_filter(item, 3, date, supplementary)
    f = find_filter_by_item(item)
    f.state = 3
    if f.date.nil?
      f.date = date
    end
    f.save
  end
  unless otherwise_public?(item) 
     if item.class != Paper
      item.is_public = false
      item.save
     end
  end
end

# Check to see if an item is public under any other group.
def otherwise_public?(item)
    item.groups.each do |g|
      if g.filter_state(item) == 1
        return true
      else
        return false
      end
    end
end

def make_filter(item, state, date = nil, supplementary = false)
  unless find_filter_by_item(item)
    if item.class == Paper
       self.filters.build(:paper_id => item.id, :state => state, :date => date, :supplementary => supplementary).save
    elsif item.class == Comment
       self.filters.build(:comment_id => item.id, :state => state).save
    elsif item.class == Question
       self.filters.build(:question_id => item.id, :state => state).save
    elsif item.class == Assertion
       self.filters.build(:assertion_id => item.id, :state => state).save
    end
  end
end


# Functions for finding info about filters

def filter_state(item)
  if !find_filter_by_item(item).nil? 
    find_filter_by_item(item).state
  elsif item.is_public?
    1
  else
    3
  end
end

def includes_item?(item)
  if find_filter_by_item(item)
     return true
  else
     return false
  end
end 

def find_filter_by_item(item)
  if item.class == Paper
     self.filters.find_by_paper_id(item.id)
  elsif item.class == Comment
     self.filters.find_by_comment_id(item.id)   
  elsif item.class == Question
     self.filters.find_by_question_id(item.id)
  elsif item.class == Assertion
     self.filters.find_by_assertion_id(item.id)  
  end
end

# Filtering Functions

def filter_count(array, user, mode = 1)
    items = []
    array.select{|c| let_through_filter?(c,user, mode)}.each do |item|
     items << item
     if item.class == Comment
       items << item.comments
     end
    end
    items.flatten.count
end
 

def let_through_filter?(item, user, mode = 1)
# Classes can see everyone's comments, but only their own assertions until the instructor flips a switch.
   if self.category == "class"
      if item.class == Assertion
        if user.lead_of?(self)
           return true
        elsif item.user == user
           return true
        elsif filter_state(item).nil?
          return false
        elsif filter_state(item) >= filter_state(item.get_paper)
          return true
        else
          return false
        end
      else
        (user.member_of?(self) && filter_state(item) <= 2)
      end
   elsif category == "lab"
# Lab members can see one another's comments and questions. All of their assertions are public. They can also see public discussion. 
      if item.class == Assertion
        return item.is_public
      elsif mode == 2 
        return (user.member_of?(self) && filter_state(item) == 2)
      elsif mode == 1
        return item.is_public
      end         
   elsif category.nil?
       return item.is_public
   end
end

def feed
   items = []
   items << shares
   users.each do |u|
     items << u.assertions
     items << u.comments
     items << u.questions
   end
   items.flatten!.sort!{|x,y| y.updated_at <=> x.updated_at}.first(100) unless items.empty?
end

def fix_visits
    Visit.all.each do |v|
     if v.count.nil?
        v.count = 0
        v.save
     end
     if v.count == 0
        v.count = 1
        v.save
     end
    end
end

#Create a list of the most viewed papers

def most_viewed
    visits = []
    users.each do |u|
      visits << u.visits
    end
    papers = visits.flatten!.map{|v| v.paper}.uniq
    papers.map{|paper| [paper, visits.select{|v| v.paper == paper}.map{|v| v.count}.inject(0){|sum, item| sum + item}]}.sort{|x,y| y[1]<=>x[1]}.first(30)
end

# List of papers by summary requests for the lab 
def sumreq_feed
   sumreqs.map{|s| s.get_paper}.uniq.map{|p| [p, p.meta_sumreqs.select{|s| s.group == self && !s.summarized}.count]}.sort!{|x,y| y[1] <=> x[1]} unless sumreqs.empty?
end
   
end
