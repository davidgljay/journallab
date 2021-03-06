class SwitchUsersToDevise < ActiveRecord::Migration
  def self.up

    change_table(:users) do |t|
      t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
    end

  rename_column :users, :salt, :password_salt  
  add_index :users, :confirmation_token,   :unique => true
  add_index :users, :reset_password_token, :unique => true
  end

  def self.down
  remove_column :users, :verified
  remove_column :users, :confirmation_token
  remove_column :users, :confirmed_at
  remove_column :users, :confirmation_sent_at
  remove_column :users, :reset_password_token
  remove_column :users, :remember_token
  remove_column :users, :remember_created_at
  remove_column :users, :sign_in_count
  remove_column :users, :current_sign_in_at
  remove_column :users, :last_sign_in_at
  remove_column :users, :current_sign_in_ip
  remove_column :users, :last_sign_in_ip
  #rename_column :users, :password_salt, :salt
  end
end
