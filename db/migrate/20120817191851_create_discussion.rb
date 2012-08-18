class CreateDiscussion < ActiveRecord::Migration
  def up
    create_table :discussions do |t|
      t.string  :name
      t.integer :paper_id
      t.integer :user_id
      t.integer :group_id
      t.datetime :starttime
      t.datetime :endtime

      t.timestamps
    end

    add_column :groups, :public, :boolean

  end

  def down
     drop_table :discussions
     remove_column :groups, :public
  end


end
