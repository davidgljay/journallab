class Subscription < ActiveRecord::Base

belongs_to :user

# Note- when adding or removing a class of email please also check the mailer.rb file and the subscriptions method in user_controller.rb.

  def defaults
    ['weekly', 'alerts', 'reply', 'jclub', 'impact', 'author', 'milestone']
  end

end
