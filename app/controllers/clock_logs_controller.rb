# frozen_string_literal: true

class ClockLogsController < ApplicationController
  before_action :set_clock_log, only: %i[show update destroy]

  # GET /clock_logs.json
  def index
    @clock_logs = current_user.clock_logs
  end

  # GET /clock_logs/1.json
  def show; end

  # POST /clock_logs.json
  def create
    @clock_log = current_user.clock_logs.new(clock_log_params)

    if @clock_log.save
      render :show, status: :created, location: @clock_log
    else
      render json: @clock_log.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clock_logs/1.json
  def update
    if @clock_log.update(clock_log_params)
      render :show, status: :ok, location: @clock_log
    else
      puts @clock_log.errors.join('\n')
      render json: @clock_log.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clock_logs/1.json
  def destroy
    @clock_log.destroy
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_clock_log
    @clock_log = ClockLog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def clock_log_params
    params.require(:clock_log).permit(:clocked_in_at, :clocked_out_at)
  end
end
