FactoryGirl.define do 

  factory :user do
     firstname			"David"
     lastname        "Jay"
     password		        "testingtesting123"
     password_confirmation 	"testingtesting123"
	 sequence(:email) {|n| "email#{n}@journallab.edu" }
     confirmed_at 			Time.now
  end

  factory :paper do
    title     "The Smartest Science Ever"
    sequence(:pubmed_id) {|n| 21230106 + n}
    abstract  "Smart smart smartypants"
    authors [{:firstname=>"Fowzia", :lastname=>"Ibrahim", :name=>"Ibrahim, Fowzia"}, {:firstname=>"Lisa", :lastname=>"Hamzah", :name=>"Hamzah, Lisa"}, {:firstname=>"Rachael", :lastname=>"Jones", :name=>"Jones, Rachael"}, {:firstname=>"Dorothea", :lastname=>"Nitsch", :name=>"Nitsch, Dorothea"}, {:firstname=>"Caroline", :lastname=>"Sabin", :name=>"Sabin, Caroline"}, {:firstname=>"Frank A", :lastname=>"Post", :name=>"Post, Frank A"}, {:firstname=>"", :lastname=>"", :name=>", "}]
    pubdate Time.now - 1.week
  end

  factory :summarized_paper do
    title     "The Smartest Science Ever"
    pubmed_id "21228906"
    abstract  "Smart smart smartypants"
    save
    buildout([3,3,2,1])
  end    

  factory :group do
    name  "Test Group"
    desc  "This group is awesome"
    category "lab"
  end
		

  factory :comment do
    text "Lorem ipsum."
    association :user
    association :paper, :pubmed_id => 21228907, :title => "The Smartest Science Ever"
    association :assertion
    form "comment"
  end

  factory :question do
    text "Lorem ipsum?"
    #association :user, :email => 'unique2@email.com'
    association :paper, :pubmed_id => 21228908, :title => "The Second Smartest Science Ever"
    association :assertion
  end

 
  factory :assertion do
    text "This is grande!"
    association :user
    association :paper
  end

  factory :author do 
    firstname "Robert"
    lastname "Judson"
    initial "RJ"
  end

end
