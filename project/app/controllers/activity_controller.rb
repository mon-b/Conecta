class ActivityController < ApplicationController
  def index
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
  end

  def edit
  end
end
