Factory.sequence :email do |n|
  "person-#{n}@example.edu"
end

Factory.sequence :pubmed_id do |n|
  21230106 + 1
end	

Factory.define :user do |user|
     user.firstname			"David"
     user.lastname                      "Jay"
     user.password		        "testingtesting123"
     user.password_confirmation 	"testingtesting123"
     user.email                         rand(100).to_s + "chick@email.edu"
     user.confirmed_at 			Time.now
#     user.save
end

Factory.define :paper do |paper|
    paper.title     "The Smartest Science Ever"
    paper.pubmed_id 21228906
    paper.abstract  "Smart smart smartypants"
    paper.pubdate Time.now - 1.week
    #paper.after_create { |p| Factory(:author, :papers => [p]) }
end

Factory.define :summarized_paper do |paper|
    paper.title     "The Smartest Science Ever"
    paper.pubmed_id "21228906"
    paper.abstract  "Smart smart smartypants"
    paper.save
    paper.buildout([3,3,2,1])
#    paper.association :assertion
#    paper.figs.each do |f|
#      f.association   :assertion
#      f.figsections.each do |s|
#         s.association :assertion
#      end 
#    end

end    

Factory.define :group do |group|
    group.name  "Test Group"
    group.desc  "This group is awesome"
    group.category "lab"
end
		

Factory.define :comment do |comment|
    comment.text "Lorem ipsum."
    comment.association :user, :email => 'unique1@email.com'
    comment.association :paper, :pubmed_id => 21228907, :title => "The Smartest Science Ever"
    comment.association :assertion
    comment.form "comment"
end

Factory.define :question do |comment|
    comment.text "Lorem ipsum?"
    comment.association :user, :email => 'unique2@email.com'
    comment.association :paper, :pubmed_id => 21228908, :title => "The Second Smartest Science Ever"
    comment.association :assertion
end

#Factory.sequence :pubmed do |n|
#   rand(9999999999) + 100
#end
 
Factory.define :assertion do |assert|
    assert.text "This is grande!"
    assert.association :user
    assert.association :paper
end

Factory.define :author do |author|
    author.firstname "Robert"
    author.lastname "Judson"
    author.initial "RJ"
end
