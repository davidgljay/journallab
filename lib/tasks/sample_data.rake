
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end

  def make_users
    admin = User.create!(:firstname => "Example",
                 :lastname => "User",
                 :email => "example@user.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    admin.toggle!(:admin)

    99.times do |n|
      firstname  = Faker::Name.first_name
      lastname = Faker::Name.last_name
      email = "example-#{n+1}@example.org"
      password  = "password"
      User.create!(:firstname => firstname,
                   :lastname => lastname,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end

  def make_microposts  
    User.all(:limit => 6).each do |user|
      50.times do
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end

  def make_relationships
    users = User.all
    user = users.first
    following = users[1..50]
    followers = users[3..40]
    following.each { |followed| user.follow!(followed) }
    followers.each { |follower| follower.follow!(user) }
  end
end
