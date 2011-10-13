class AddIndexes < ActiveRecord::Migration
  def self.up
   add_index :votes, :assertion_id
   add_index :assertions, :paper_id
   add_index :assertions, :fig_id
   add_index :assertions, :figsection_id
   add_index :assertions, :user_id
   add_index :figsections, :fig_id
   add_index :figs, :paper_id
   add_index :comments, :paper_id
   add_index :comments, :fig_id
   add_index :comments, :figsection_id
   add_index :comments, :user_id
   add_index :questions, :paper_id
   add_index :questions, :fig_id
   add_index :questions, :figsection_id
   add_index :questions, :user_id
   add_index :memberships, :user_id
   add_index :filters, :assertion_id
   add_index :filters, :comment_id
   add_index :filters, :question_id
   add_index :filters, :paper_id
  end

  def self.down
   remove_index :authorships, :paper_id
   remove_index :votes, :assertion_id
   remove_index :assertions, :paper_id
   remove_index :assertions, :fig_id
   remove_index :assertions, :figsection_id
   remove_index :assertions, :user_id
   remove_index :figsections, :fig_id
   remove_index :figs, :paper_id
   remove_index :comments, :paper_id
   remove_index :comments, :fig_id
   remove_index :comments, :figsection_id
   remove_index :comments, :user_id
   remove_index :questions, :paper_id
   remove_index :questions, :fig_id
   remove_index :questions, :figsection_id
   remove_index :questions, :user_id
   remove_index :memberships, :user_id
   remove_index :filters, :assertion_id
   remove_index :filters, :comment_id
   remove_index :filters, :question_id
   remove_index :filters, :paper_id
  end
end
