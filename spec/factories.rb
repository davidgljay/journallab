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
