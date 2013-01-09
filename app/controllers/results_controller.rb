class ResultsController < ApplicationController
  # GET /results
  # GET /results.json
  def index
    @scenario = Scenario.find(params[:scenario_id])
    @results = @scenario.results.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @results }
    end
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @scenario = Scenario.find(params[:scenario_id])
    @result = @scenario.results.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @result }
    end
  end


  # GET /results/1/edit
  def edit
    # Could have a 'edit' to put notes on it or something...
    @result = Result.find(params[:id])
  end

  # PUT /results/1
  # PUT /results/1.json
  def update
    @result = Result.find(params[:id])

    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :no_content }
    end
  end
end
