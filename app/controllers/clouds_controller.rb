class CloudsController < ApplicationController
  # GET /clouds
  # GET /clouds.xml
  def index
    @clouds = Cloud.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clouds }
    end
  end

  # GET /clouds/1
  # GET /clouds/1.xml
  def show
    @cloud = Cloud.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xml  { render :xml => @cloud }
    end
  end

  # GET /clouds/new
  # GET /clouds/new.xml
  def new
    @cloud = Cloud.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cloud }
    end
  end

  # GET /clouds/1/edit
  # def edit
  #   @cloud = Cloud.find(params[:id])
  # end

  # POST /clouds
  # POST /clouds.xml
  def create
    @cloud = Cloud.new(params[:cloud])

    respond_to do |format|
      if @cloud.save
        call_rake :create_cloud, :cloud_id => @cloud.id
        format.html { redirect_to(@cloud, :notice => 'Cloud was successfully created.') }
        format.xml  { render :xml => @cloud, :status => :created, :location => @cloud }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cloud.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clouds/1
  # PUT /clouds/1.xml
  def update
    @cloud = Cloud.find(params[:id])

    respond_to do |format|
      if @cloud.update_attributes(params[:cloud])
        format.html { redirect_to(@cloud, :notice => 'Cloud was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cloud.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /clouds/1
  # DELETE /clouds/1.xml
  def destroy
    @cloud = Cloud.find(params[:id])
    @cloud.destroy

    respond_to do |format|
      format.html { redirect_to(clouds_url) }
      format.xml  { head :ok }
    end
  end
end
