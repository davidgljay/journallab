require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe PapersController do

  def mock_paper(stubs={})
    @mock_paper ||= mock_model(Paper, stubs).as_null_object
  end


  describe "user functions" do
    before(:each) do
      @paper = Factory(:paper)
      @paper.lookup_info
      @user = Factory(:user)
      test_sign_in(@user)
    end
  

    describe "GET show" do
      it "assigns the requested paper as @paper" do
        get :show, :id => @paper.id
        assigns(:paper).should == @paper
      end
    end

    describe "pubmed id lookup" do
   
      it "should look up an existing paper" do
        get :lookup, :pubmed_id => @paper.pubmed_id.to_s
        response.should redirect_to(@paper)
      end
    end

    describe "show from mail" do
       
       before(:each) do
          @maillog = Maillog.create!(:user => @user, :about => @paper, :purpose => 'comment_response')
       end

       it "should mark a conversion if the paper matches" do
          get :show_from_mail, :id => @paper.id, :m_id => @maillog.id
          Maillog.find(@maillog.id).conversiona.should_not be nil
          response.should redirect_to(@paper)
       end

       it "should not mark a conversion if the paper does not match" do
          @paper2 = Factory(:paper, :pubmed_id => '7809879')
          get :show_from_mail, :id => @paper2.id, :m_id => @maillog.id
          @maillog.conversiona.should be nil
          response.should redirect_to(@paper2)
       end
    end
  end
  
  describe "admin function" do
  
     before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
     end

    describe "GET index" do
      it "assigns all papers as @papers" do
        @paper = Factory(:paper)
        get :index
        assigns(:papers).should eq([@paper])
      end
    end

     describe "with valid params" do
        it "assigns a newly created paper as @paper" do
          Paper.stub(:new).with({'these' => 'params'}) { mock_paper(:save => true) }
          post :create, :paper => {'these' => 'params'}
          assigns(:paper).should be(mock_paper)
        end

        it "redirects to the created paper" do
          Paper.stub(:new) { mock_paper(:save => true) }
          post :create, :paper => {}
          response.should redirect_to(paper_url(mock_paper))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved paper as @paper" do
          Paper.stub(:new).with({'these' => 'params'}) { mock_paper(:save => false) }
          post :create, :paper => {'these' => 'params'}
          assigns(:paper).should be(mock_paper)
        end

        it "re-renders the 'new' template" do
          Paper.stub(:new) { mock_paper(:save => false) }
          post :create, :paper => {}
          response.should render_template("new")
        end
      end

      describe "DELETE destroy" do
        it "destroys the requested paper" do
          Paper.stub(:find).with("37") { mock_paper }
          mock_paper.should_receive(:destroy)
          delete :destroy, :id => "37"
        end

        it "redirects to the papers list" do
          Paper.stub(:find) { mock_paper }
            delete :destroy, :id => "1"
          response.should redirect_to(papers_url)
        end
      end
    end
end
