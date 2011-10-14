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
    paper.pubmed_id rand(999999999) + 100
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
