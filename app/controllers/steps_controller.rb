class StepsController < ApplicationController
  # GET /steps
  # GET /steps.json
  def index
    @scenario = Scenario.find(params[:scenario_id])
    @steps = @scenario.steps.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
    @scenario = Scenario.find(params[:scenario_id])
    @step = Step.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.json
  def new
    @scenario = Scenario.find(params[:scenario_id])
    @step = @scenario.steps.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @scenario = Scenario.find(params[:scenario_id])
    @step = @scenario.steps.find(params[:id])
  end

  # POST /steps
  # POST /steps.json
  def create
    @scenario = Scenario.find(params[:scenario_id])
    @step = @scenario.steps.new(params[:step])

    respond_to do |format|
      if @step.save
        format.html { redirect_to scenario_steps_path(@scenario), notice: 'Step was successfully created.' }
        format.json { render json: @step, status: :created, location: @step }
      else
        format.html { render action: "new" }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.json
  def update
    @scenario = Scenario.find(params[:scenario_id])
    @step = @scenario.steps.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to scenario_steps_path(@scenario), notice: 'Step was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @scenario = Scenario.find(params[:scenario_id])
    @step = @scenario.steps.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to scenario_steps_url(@scenario) }
      format.json { head :no_content }
    end
  end
end
