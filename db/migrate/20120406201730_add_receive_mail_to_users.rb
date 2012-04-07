class AddReceiveMailToUsers < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string :category
      t.integer :user_id
      t.boolean :receive_mail
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
