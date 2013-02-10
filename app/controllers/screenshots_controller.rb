class ScreenshotsController < ApplicationController
  before_filter :check_token, :except => [:new, :about, :index, :create, :api]
  # GET /screenshots
  # GET /screenshots.json
  def index
    @screenshots = Screenshot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @screenshots }
    end
  end

  # GET /screenshots/1
  # GET /screenshots/1.json
  def show
    @screenshot = Screenshot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @screenshot }
    end
  end

  def about
    # just a static html page
  end

  def api
    # just a static html page
  end

  # GET /scenarios/1/run
  # GET /scenarios/1/run.json
  def run
    @screenshot = Screenshot.find(params[:id])
    #@scenario.run
    @screenshot.delivered = nil
    @screenshot.save
    Resque.enqueue(Screenshot, @screenshot.id)

    respond_to do |format|
      format.html { redirect_to screenshot_path(@screenshot,
                          :token => @screenshot.token, 
                          :email => @screenshot.email), 
                        notice: 'Screenshot was successfully queued up.' }
      format.json { render json: @screenshot, status: :created, location: @screenshot }
    end
  end

  # GET /screenshots/new
  # GET /screenshots/new.json
  def new
    @screenshot = Screenshot.new
    @screenshot.sizes.build(height: 900, width: 1200)
    @screenshot.sizes.build(height: 600, width: 768)
    @screenshot.sizes.build(height: 480, width: 320)
    @button = "Send"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @screenshot }
    end
  end

  # GET /screenshots/1/edit
  def edit
    @screenshot = Screenshot.find(params[:id])
    @button = "Update"
    @update = true
  end

  # POST /screenshots
  # POST /screenshots.json
  def create
    @screenshot = Screenshot.new(params[:screenshot])
    #@screenshot.sizes.build(params[:sizes_attributes][0])

    respond_to do |format|
      if @screenshot.save
        Resque.enqueue(Screenshot, @screenshot.id)
        format.html { redirect_to screenshot_path(@screenshot,
                          :token => @screenshot.token, 
                          :email => @screenshot.email), notice: 'Screenshot was queued up for delivery.' }
        format.json { render json: @screenshot, status: :created, location: @screenshot }
      else
        format.html { render action: "new" }
        format.json { render json: @screenshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /screenshots/1
  # PUT /screenshots/1.json
  def update
    @screenshot = Screenshot.find(params[:id])
    @screenshot.delivered = nil
    respond_to do |format|
      if @screenshot.update_attributes(params[:screenshot])
        Resque.enqueue(Screenshot, @screenshot.id)
        format.html { redirect_to screenshot_path(@screenshot,
                          :token => @screenshot.token, 
                          :email => @screenshot.email), notice: 'Screenshot was successfully updated and queued for delivery.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @screenshot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /screenshots/1
  # DELETE /screenshots/1.json
  def destroy
    @screenshot = Screenshot.find(params[:id])
    @screenshot.destroy

    respond_to do |format|
      format.html { redirect_to screenshots_url }
      format.json { head :no_content }
    end
  end

  private

    def check_token
      # TODO: Cleanup
      @screenshot = Screenshot.find(params[:id])
      if request.get?
        unless params[:token] && params[:email] && params[:token] == @screenshot.token && params[:email] == @screenshot.email
          not_found
        end
      else
        unless params[:screenshot][:token] && params[:screenshot][:token] == @screenshot.token
          not_found
        end
      end
    end
end
