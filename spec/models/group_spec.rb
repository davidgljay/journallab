require 'spec_helper'

describe Group do

  describe "adding users" do
	it "should send an e-mail to the group lead" do
		@group = create(:group)
		@lead = create(:user)
		@newuser = create(:user)
		@group.add(@lead)
		@group.make_lead(@lead)
		@group.add(@newuser)
		Maillog.last.about.should == @group
		Maillog.last.user_id.should == @lead.id
	end
  end
end
