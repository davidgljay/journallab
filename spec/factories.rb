Factory.define :user do |user|
   user.name			"David Jay"
   user.email			"davidgljay@gmail.com"
   user.password		"testingtesting123"
   user.password_confirmation 	"testingtesting123"
end

Factory.sequence :email do |n|
   "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
    micropost.content "Foo bar"
    micropost.association :user
end

Factory.define :paper do |paper|
    paper.pubmed_id "18276894"
end

Factory.sequence :pubmed do |n|
   "1827289#{n}"
end
 
Factory.define :assertion do |assert|
    assert.text "This is grande!"
    assert.association :user
    assert.association :paper
end
