Factory.sequence :email do |n|
  "person-#{n}@example.com"
end


Factory.define :user do |user|
     user.firstname			"David"
     user.lastname                      "Jay"
     user.password		        "testingtesting123"
     user.password_confirmation 	"testingtesting123"
     user.email                         "sample@email.com"
end


Factory.define :micropost do |micropost|
    micropost.content "Foo bar"
    micropost.association :user
end

Factory.define :paper do |paper|
    paper.title     "The Smartest Science Ever"
    paper.pubmed_id rand(999999999) + 100
    paper.abstract  "Smart smart smartypants"
end

Factory.define :summarized_paper do |paper|
    paper.title     "The Smartest Science Ever"
    paper.pubmed_id rand(999999999) + 100
    paper.abstract  "Smart smart smartypants"
    paper.save
    paper.buildout([3,3,2,1])

end    

Factory.define :comment do |comment|
    comment.text "Lorem ipsum."
    comment.association :user, :email => "unique@email.com"
    comment.association :paper, :pubmed_id => rand(999999999) + 100
    comment.association :assertion
    comment.form "comment"
end

#Factory.sequence :pubmed do |n|
#   rand(9999999999) + 100
#end
 
Factory.define :assertion do |assert|
    assert.text "This is grande!"
    assert.association :user
    assert.association :paper
end
