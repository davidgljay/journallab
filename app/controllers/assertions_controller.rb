class AssertionsController < ApplicationController
  # GET /assertions
  # GET /assertions.xml
  def index
    @assertions = Assertion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assertions }
    end
  end

  # GET /assertions/1
  # GET /assertions/1.xml
  def show
    @assertion = Assertion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assertion }
    end
  end

  # GET /assertions/new
  # GET /assertions/new.xml
  def new
    @assertion = Assertion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assertion }
    end
  end

  # GET /assertions/1/edit
  def edit
    @assertion = Assertion.find(params[:id])
  end

  # POST /assertions
  # POST /assertions.xml
  def create
    @assertion = Assertion.new(params[:assertion])

    respond_to do |format|
      if @assertion.save
        format.html { redirect_to(@assertion, :notice => 'Assertion was successfully created.') }
        format.xml  { render :xml => @assertion, :status => :created, :location => @assertion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assertion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assertions/1
  # PUT /assertions/1.xml
  def update
    @assertion = Assertion.find(params[:id])

    respond_to do |format|
      if @assertion.update_attributes(params[:assertion])
        format.html { redirect_to(@assertion, :notice => 'Assertion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assertion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assertions/1
  # DELETE /assertions/1.xml
  def destroy
    @assertion = Assertion.find(params[:id])
    @assertion.destroy

    respond_to do |format|
      format.html { redirect_to(assertions_url) }
      format.xml  { head :ok }
    end
  end
end
