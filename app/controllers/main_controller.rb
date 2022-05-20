class MainController < ApplicationController
  def index
    @q = Property.ransack(params[:q])
    @properties = @q.result.page params[:page]
  end

  def show
  end
end